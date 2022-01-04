#!/bin/bash

cleanup()
{
    # 删除文件夹后重建，替代 rm -rf $OUTPUT_DIR/*
    # 防止变量 OUTPUT_DIR，执行成 rm -rf /*
    rm -rf $OUTPUT_DIR
    mkdir -p $OUTPUT_DIR
}

main()
{
    log "start to cleanup ..."

    cleanup || return

    log "cleanup finish !"
}

main
