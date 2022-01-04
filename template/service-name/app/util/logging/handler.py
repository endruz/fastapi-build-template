#!/usr/bin/env python
# coding:utf-8

import os
import time
from logging.handlers import TimedRotatingFileHandler


class MultiProcessSafeTimedRotatingFileHandler(TimedRotatingFileHandler):
    """
    该类是对 TimedRotatingFileHandler 的重写，已解决其多进程不安全，丢失日志的问题

    TimedRotatingFileHandler 文件切割的逻辑为:

    1. 判断准备切入的文件 error.log.2021-11-11 是否存在，如果存在，则删除该文件
    2. 然后把 error.log 重命名为 error.log.2021-11-11
    3. doRollover 结束，FileHandler.emit 将消息写入 error.log (新建)

    修改后逻辑如下所示。
    """

    def __init__(
        self,
        filename,
        when="h",
        interval=1,
        backupCount=0,
        encoding=None,
        delay=False,
        utc=False,
        atTime=None,
    ):
        super().__init__(
            filename,
            when=when,
            interval=interval,
            backupCount=backupCount,
            encoding=encoding,
            delay=delay,
            utc=utc,
            atTime=atTime,
        )

    def doRollover(self):
        """
        do a rollover; in this case, a date/time stamp is appended to the filename
        when the rollover happens. However, you want the file to be named for the
        start of the interval, not the current time. If there is a backup count,
        then we have to get a list of matching filenames, sort them and remove
        the one with the oldest suffix.
        """
        if self.stream:
            self.stream.close()
            self.stream = None
        # get the time that this sequence started at and make it a TimeTuple
        currentTime = int(time.time())
        dstNow = time.localtime(currentTime)[-1]
        t = self.rolloverAt - self.interval
        if self.utc:
            timeTuple = time.gmtime(t)
        else:
            timeTuple = time.localtime(t)
            dstThen = timeTuple[-1]
            if dstNow != dstThen:
                if dstNow:
                    addend = 3600
                else:
                    addend = -3600
                timeTuple = time.localtime(t + addend)
        dfn = self.rotation_filename(
            self.baseFilename + "." + time.strftime(self.suffix, timeTuple)
        )
        # 修改代码
        # 在多进程下，判断 dfn 是否存在：
        # 若 dfn 已存在，则表示已经有其他进程将日志文件按时间切割了，只需重新打开新的日志文件，写入当前日志；
        # 若 dfn 不存在，则将当前日志文件重命名，并打开新的日志文件。
        if not os.path.exists(dfn):
            try:
                self.rotate(self.baseFilename, dfn)
            except FileNotFoundError:
                # 这里可能会报 FileNotFoundError
                # 原因是其他进程对该日志文件重命名了
                # pass 即可，当前日志内容不会丢失，还会输出到重命名后的文件中
                pass
        # 原代码
        """
        if os.path.exists(dfn):
        os.remove(dfn)
        self.rotate(self.baseFilename, dfn)
        """

        if self.backupCount > 0:
            for s in self.getFilesToDelete():
                os.remove(s)
        if not self.delay:
            self.stream = self._open()
        newRolloverAt = self.computeRollover(currentTime)
        while newRolloverAt <= currentTime:
            newRolloverAt = newRolloverAt + self.interval
        # If DST changes and midnight or weekly rollover, adjust for this.
        if (self.when == "MIDNIGHT" or self.when.startswith("W")) and not self.utc:
            dstAtRollover = time.localtime(newRolloverAt)[-1]
            if dstNow != dstAtRollover:
                if (
                    not dstNow
                ):  # DST kicks in before next rollover, so we need to deduct an hour
                    addend = -3600
                else:  # DST bows out before next rollover, so we need to add an hour
                    addend = 3600
                newRolloverAt += addend
        self.rolloverAt = newRolloverAt
