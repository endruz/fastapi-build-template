#!/usr/bin/env python
# coding:utf-8

import os
import shutil
from glob import iglob
from datetime import datetime

from app.config import cfg
from app.util import Logger

logger = Logger()


async def cleanup_tmp():
    logger.info("cleanup tmp start...")
    tmp_path = cfg.tmp_path
    current_time = datetime.now()
    for file_path in iglob(os.path.join(tmp_path, "*")):
        # 获取文件 change time 的时间戳
        timestamp = os.path.getctime(file_path)
        file_create_time = datetime.fromtimestamp(timestamp)
        delta = current_time - file_create_time
        days = delta.days
        seconds = delta.seconds
        total_minute = days * 24 * 60 + round(seconds / 60)
        # 删除创建时间大于 15 分钟的文件
        if total_minute > 15:
            try:
                os.remove(file_path)
            except IsADirectoryError:
                shutil.rmtree(file_path)
            except FileNotFoundError:
                pass
            logger.info(f"rm {file_path}")
    logger.info("cleanup tmp over...")
