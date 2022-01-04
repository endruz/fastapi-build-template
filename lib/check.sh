#!/bin/bash

check_files()
{
    local tpl_dir="$TEMPLATE_DIR/tpl"
    local build_dir="$TEMPLATE_DIR/build"
    local config_dir="$TEMPLATE_DIR/service-name/app/config"

    local service_config_tpl="$TEMPLATE_DIR/tpl/cfg.py.tpl"
    local logging_config_tpl="$TEMPLATE_DIR/tpl/log_cfg.py.tpl"
    local gitignore_tpl="$TEMPLATE_DIR/tpl/gitignore.tpl"
    local requirements_dev_tpl="$TEMPLATE_DIR/tpl/requirements_dev.txt.tpl"
    local build_config_tpl="$TEMPLATE_DIR/tpl/config.tpl"
    local dockerignore_tpl="$TEMPLATE_DIR/tpl/dockerignore.tpl"
    local dockerfile_tpl="$TEMPLATE_DIR/tpl/Dockerfile.tpl"
    local cybuild_dockerfile_tpl="$TEMPLATE_DIR/tpl/cybuild.Dockerfile.tpl"
    local run_container_tpl="$TEMPLATE_DIR/tpl/run_container.sh.tpl"
    local build_tpl="$TEMPLATE_DIR/tpl/build.sh.tpl"
    local makefile_tpl="$TEMPLATE_DIR/tpl/Makefile.tpl"

    check_dirs_exist $tpl_dir $build_dir $config_dir || return
    check_files_exist $service_config_tpl $logging_config_tpl $gitignore_tpl \
    $requirements_dev_tpl $build_config_tpl $dockerignore_tpl $dockerfile_tpl \
    $cybuild_dockerfile_tpl $run_container_tpl $build_tpl $makefile_tpl || return
}

main()
{
    log "start to check ..."

    check_files || return

    log "check finish !"
}

main
