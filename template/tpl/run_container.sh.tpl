#!/bin/bash

BUILD_DIR=$(dirname $(dirname $0))
ROOT_DIR=$(dirname $BUILD_DIR)

log_info()
{
    echo -e "info: $*" >&2
}

log_warn()
{
    echo -e "\\x1b[1;33mwarn: $*\\x1b[0m" >&2
}

log_error()
{
    echo -e "\\x1b[1;31merror: $* \\x1b[0m" >&2
}

check_files_exist()
{
    local files="$@"

    for file in $files; do
        [[ -s "$file" ]] || {
            log_error "cannot find file: $file"
            return 1
        }
    done
}

parse_build_config()
{
    log_info "parse build config ..."
    local config_file="$BUILD_DIR/config"
    check_files_exist $config_file || return
    source $config_file

    # 处理 IMAGE_TAG
    if [ -z $IMAGE_TAG ]; then
        IMAGE_TAG="latest"
    fi
}

run_container()
{
    log_info "run docker container ..."

    local image_name="$IMAGE_NAME:$IMAGE_TAG"
    local run_params="-d --name $CONTAINER_NAME --restart=always"

    if [[ $PORT ]]; then
        run_params+=" -p $PORT:8080"
    else
        run_params+=" -p 8080:8080"
    fi

    if [[ $GPUS ]]; then
        run_params+=" --gpus device=$GPUS"
    fi

    if [[ $LOG_PATH ]]; then
        run_params+=" -v $LOG_PATH:/@SERVICE_NAME@/log"
    fi

    if [[ $TMP_PATH ]]; then
        run_params+=" -v $TMP_PATH:/@SERVICE_NAME@/tmp"
    fi

    if [[ $IS_CLEANUP_TMP && "$IS_CLEANUP_TMP" = "NO" ]]; then
        run_params+=" -e IS_CLEANUP_TMP=False"
    fi

    if [[ $WEB_CONCURRENCY ]]; then
        run_params+=" -e WEB_CONCURRENCY=$WEB_CONCURRENCY"
    fi

    set -x

    docker run $run_params $image_name || return

    set +x
}


main()
{
    parse_build_config || return
    run_container || return
}

main
