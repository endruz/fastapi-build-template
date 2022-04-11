#!/bin/bash

init_service()
{
    log_info "init service ..."
    # 使用 . 可以拷贝隐藏文件，* 不可以
    cp -r $TEMPLATE_DIR/. $OUTPUT_DIR
    mv $OUTPUT_DIR/service-name $OUTPUT_DIR/$SERVICE_NAME
}

generate_service_config()
{
    log_info "generate service config ..."

    local service_config_tpl="$OUTPUT_DIR/tpl/cfg.py.tpl"
    local service_config_file="$OUTPUT_DIR/$SERVICE_NAME/app/config/cfg.py"
    sed -e "s/@SERVICE_NAME@/$SERVICE_NAME/g" \
        -e "s/@VERSION@/$VERSION/g" \
        -e "s/@MAINTAINER@/$MAINTAINER_LIST/g" \
    $service_config_tpl > $service_config_file || return

    local logging_config_tpl="$OUTPUT_DIR/tpl/log_cfg.py.tpl"
    local logging_config_file="$OUTPUT_DIR/$SERVICE_NAME/app/config/log_cfg.py"
    sed -e "s/@SERVICE_NAME@/$SERVICE_NAME/g" $logging_config_tpl > $logging_config_file || return

    local gitignore_tpl="$OUTPUT_DIR/tpl/gitignore.tpl"
    local gitignore_file="$OUTPUT_DIR/.gitignore"
    sed -e "s/@SERVICE_NAME@/$SERVICE_NAME/g" $gitignore_tpl > $gitignore_file || return

    local requirements_dev_tpl="$OUTPUT_DIR/tpl/requirements_dev.txt.tpl"
    local requirements_dev_file="$OUTPUT_DIR/requirements_dev.txt"
    sed -e "s/@SERVICE_NAME@/$SERVICE_NAME/g" $requirements_dev_tpl > $requirements_dev_file || return
}

generate_build_config()
{
    log_info "generate build config ..."

    local build_config_tpl="$OUTPUT_DIR/tpl/config.tpl"
    local build_config_file="$OUTPUT_DIR/build/config"
    sed -e "s/@SERVICE_NAME@/$SERVICE_NAME/g" $build_config_tpl > $build_config_file || return

    local dockerignore_tpl="$OUTPUT_DIR/tpl/dockerignore.tpl"
    local dockerignore_file="$OUTPUT_DIR/.dockerignore"
    sed -e "s/@SERVICE_NAME@/$SERVICE_NAME/g" $dockerignore_tpl > $dockerignore_file || return

    local dockerfile_tpl="$OUTPUT_DIR/tpl/Dockerfile.tpl"
    local dockerfile_file="$OUTPUT_DIR/build/docker/Dockerfile"
    sed -e "s/@SERVICE_NAME@/$SERVICE_NAME/g" $dockerfile_tpl > $dockerfile_file || return

    local cybuild_dockerfile_tpl="$OUTPUT_DIR/tpl/Dockerfile.cybuild.tpl"
    local cybuild_dockerfile_file="$OUTPUT_DIR/build/docker/Dockerfile.cybuild"
    sed -e "s/@SERVICE_NAME@/$SERVICE_NAME/g" $cybuild_dockerfile_tpl > $cybuild_dockerfile_file || return

    local run_container_tpl="$OUTPUT_DIR/tpl/run_container.sh.tpl"
    local run_container_file="$OUTPUT_DIR/build/lib/run_container.sh"
    sed -e "s/@SERVICE_NAME@/$SERVICE_NAME/g" $run_container_tpl > $run_container_file || return
    chmod +x $run_container_file

    local build_tpl="$OUTPUT_DIR/tpl/build.sh.tpl"
    local build_file="$OUTPUT_DIR/build/lib/build.sh"
    sed -e "s/@SERVICE_NAME@/$SERVICE_NAME/g" $build_tpl > $build_file || return
    chmod +x $build_file

    local makefile_tpl="$OUTPUT_DIR/tpl/Makefile.tpl"
    local makefile="$OUTPUT_DIR/Makefile"
    sed -e "s/@SERVICE_NAME@/$SERVICE_NAME/g" $makefile_tpl > $makefile || return
}

cleanup_tpl_file()
{
    log_info "cleanup template file ..."
    rm -rf $OUTPUT_DIR/tpl
    rm -f $OUTPUT_DIR/build/docker/.gitkeep
}

main()
{
    log "start to build ..."

    init_service || return
    generate_service_config || return
    generate_build_config || return
    cleanup_tpl_file || return

    log "build finish !"
}

main
