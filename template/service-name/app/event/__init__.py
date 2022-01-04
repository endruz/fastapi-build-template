#!/usr/bin/env python
# coding:utf-8

from fastapi import FastAPI
from apscheduler.schedulers.asyncio import AsyncIOScheduler

from app.util import Logger
from app.config import cfg
from app.event.cleanup_tmp_scheduler import cleanup_tmp

logger = Logger()


def start_scheduler():
    logger.info("start_scheduler!".center(50, "="))
    scheduler = AsyncIOScheduler()
    if cfg.is_cleanup_tmp:
        scheduler.add_job(cleanup_tmp, "interval", minutes=15)
    scheduler.start()


def register_events(app: FastAPI) -> None:
    app.add_event_handler("startup", start_scheduler)


__all__ = [
    "register_events",
]
