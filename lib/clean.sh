#!/bin/bash

cleanup()
{
    if [ -d "$OUTPUT_DIR" ] ; then
        read -r -p "This operation will clear everything in the $OUTPUT_DIR, are you sure you want to perform this operation? [Y/n]" response
        # 字母转换为小写
        response=${response,,}
        if [[ $response =~ ^(yes|y| ) ]]; then
            # 删除文件夹后重建，替代 rm -rf $OUTPUT_DIR/*
            # 防止变量 OUTPUT_DIR 为空字符串，执行成 rm -rf /*
            rm -rf $OUTPUT_DIR
        else
            return 1
        fi
    fi

    mkdir -p $OUTPUT_DIR
}

main()
{
    log "start to cleanup ..."

    cleanup || {
        log "cleanup interrupts !"
        return
    }

    log "cleanup finish !"
}

main
