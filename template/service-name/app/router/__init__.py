#!/usr/bin/env python
# coding:utf-8

from fastapi import FastAPI

from app.router.root_router import root_router


def register_routers(app: FastAPI) -> None:
    app.include_router(root_router, prefix="")


__all__ = [
    "register_routers",
]
