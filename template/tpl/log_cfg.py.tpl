#!/usr/bin/env python
# coding:utf-8

log_cfg = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "trace": {
            "format": "%(asctime)s %(filename)s[line:%(lineno)d] [%(levelname)s] [%(traceid)s]: %(message)s",
            "datefmt": "%Y-%m-%d %H:%M:%S",
        },
    },
    "filters": {
        "trace_id_filter": {
            "()": "app.util.logging.filter.TraceIDFilter",
        },
    },
    "handlers": {
        "trace_console": {
            "class": "logging.StreamHandler",
            "level": "DEBUG",
            "formatter": "trace",
            "filters": ["trace_id_filter"],
            "stream": "ext://sys.stdout",
        },
        "timed_rotating_file_handler": {
            "class": "app.util.logging.handler.MultiProcessSafeTimedRotatingFileHandler",
            "level": "INFO",
            "formatter": "trace",
            "filters": ["trace_id_filter"],
            "filename": "./log/@SERVICE_NAME@.log",
            "when": "MIDNIGHT",
            "interval": 1,
            "backupCount": 15,
            "encoding": "utf8",
        },
    },
    "root": {
        "level": "DEBUG",
        "handlers": ["trace_console", "timed_rotating_file_handler"],
    },
}
