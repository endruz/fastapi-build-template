#!/bin/bash

ACTION="$1"

ROOT_PATH=$(dirname $0)
LIB_DIR="$ROOT_PATH/lib"
TEMPLATE_DIR="$ROOT_PATH/template"

CONFIG_FILE="$ROOT_PATH/config"


log()
{
    echo >&2
    echo -e "\\x1b[1;36m[$(date +%F\ %T)] $*\\x1b[0m" >&2
}

log_info()
{
    echo -e "info: $*" >&2
}

log_debug()
{
    echo -e "\\x1b[1;32mdebug: $*\\x1b[0m" >&2
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
        [[ -s $file ]] || {
            log_error "cannot find file: $file"
            return 1
        }
    done
}

check_dirs_exist()
{
    local dirs="$@"

    for dir in $dirs; do
        [[ -d "$dir" ]] || {
            log_error "cannot find directory: $dir"
            return 1
        }

        [[ $(ls --hide=".*" "$dir") ]] || {
            log_error "cannot find any non-dot valid files in $dir"
            return 1
        }
    done
}

parse_config()
{
    check_files_exist $CONFIG_FILE || return
    source $CONFIG_FILE

    # 处理 OUTPUT_DIR
    if [ -z $OUTPUT_DIR ]; then
        OUTPUT_DIR="$ROOT_PATH/output"
    fi

    # 处理 MAINTAINER, EMAIL, MAINTAINER_LIST
    local OLD_IFS="$IFS"
    IFS=","
    MAINTAINER=($MAINTAINER)
    EMAIL=($EMAIL)
    IFS="$OLD_IFS"
    local MAINTAINER_NUM=${#MAINTAINER[@]}
    local EMAIL_NUM=${#EMAIL[@]}
    MAINTAINER_LIST=""

    if [ $MAINTAINER_NUM -le $EMAIL_NUM ]; then
        for i in ${!MAINTAINER[@]}; do
            if [ -z "$MAINTAINER_LIST" ]; then
                MAINTAINER_LIST="\"${MAINTAINER[$i]} <${EMAIL[$i]}>\""
            else
                MAINTAINER_LIST="$MAINTAINER_LIST, \"${MAINTAINER[$i]} <${EMAIL[$i]}>\""
            fi
        done
    else
        for i in ${!MAINTAINER[@]}; do
            if [ $i -lt $EMAIL_NUM ]; then
                if [ -z "$MAINTAINER_LIST" ]; then
                    MAINTAINER_LIST="\"${MAINTAINER[$i]} <${EMAIL[$i]}>\""
                else
                    MAINTAINER_LIST="$MAINTAINER_LIST, \"${MAINTAINER[$i]} <${EMAIL[$i]}>\""
                fi
            else
                if [ -z "$MAINTAINER_LIST" ]; then
                    MAINTAINER_LIST="\"${MAINTAINER[$i]}\""
                else
                    MAINTAINER_LIST="$MAINTAINER_LIST, \"${MAINTAINER[$i]}\""
                fi
            fi
        done
    fi

    MAINTAINER_LIST="[$MAINTAINER_LIST]"
}

parse_config

export ROOT_PATH
export LIB_DIR
export TEMPLATE_DIR
export OUTPUT_DIR
export CONFIG_FILE
export SERVICE_NAME
export VERSION
export MAINTAINER
export EMAIL
export MAINTAINER_LIST

export -f log
export -f log_info
export -f log_debug
export -f log_warn
export -f log_error
export -f check_files_exist
export -f check_dirs_exist
# export -f parse_config


case $ACTION in
    check)
        $LIB_DIR/check.sh
        ;;
    clean)
        $LIB_DIR/clean.sh
        ;;
    build)
        $LIB_DIR/build.sh
        ;;
    *)
        log_error "cannot support \"$ACTION\" operation"
esac
