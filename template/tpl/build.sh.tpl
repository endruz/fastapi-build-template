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

build()
{
    log_info "build service env ..."

    local requirements_file="$ROOT_DIR/@SERVICE_NAME@/requirements.txt"
    check_files_exist $requirements_file || return
    pip install -r $requirements_file
}

extra_operation()
{
    # do anything if necessary
    :
}


main()
{
    build || return
    extra_operation || return
}

main
