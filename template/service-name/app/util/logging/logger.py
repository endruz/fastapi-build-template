#!/usr/bin/env python
# coding:utf-8

import logging

from app.config import log_cfg
from app.util.singleton import singleton


@singleton
class Logger:
    def __new__(cls):
        logging.config.dictConfig(log_cfg)
        cls.logger = logging.getLogger("root")
        return cls.logger
