#!/usr/bin/env python
# coding:utf-8

from fastapi import FastAPI

from app.config import cfg
from app.event import register_events
from app.router import register_routers
from app.exception import register_exceptions
from app.middleware import register_middlewares

TITLE = cfg.service_name

DESCRIPTION = f"""
## 主要实现功能:

- 待补充

## 维护者:

- {"🍔- ".join(cfg.maintainer)}
""".replace(
    "🍔", "\n"
)

VERSION = cfg.version


def create_app():
    app = FastAPI(
        title=TITLE,
        description=DESCRIPTION,
        version=VERSION,
    )
    register_events(app)
    register_routers(app)
    register_exceptions(app)
    register_middlewares(app)
    return app
