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

build_image()
{
    log_info "build docker image ..."

    local dockerfile
    local build_params
    local image_name="$IMAGE_NAME:$IMAGE_TAG"

    if [[ $ENABLE_ENCRYPT && "$ENABLE_ENCRYPT" = "YES" ]]; then
        dockerfile="$BUILD_DIR/docker/cybuild.Dockerfile"
    else
        dockerfile="$BUILD_DIR/docker/Dockerfile"
    fi

    if [[ $NO_CACHE && "$NO_CACHE" = "YES" ]]; then
        build_params+=" --no-cache"
    fi

    if [[ $ALWAYS_PULL && "$ALWAYS_PULL" = "YES" ]]; then
        build_params+=" --pull"
    fi

    docker build $build_params -t "$image_name" -f "$dockerfile" "$ROOT_DIR" || return
}


main()
{
    parse_build_config || return
    build_image || return
}

main
