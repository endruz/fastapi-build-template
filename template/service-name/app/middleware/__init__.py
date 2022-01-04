#!/usr/bin/env python
# coding:utf-8

from fastapi import FastAPI
from starlette.middleware.base import BaseHTTPMiddleware

from app.middleware.time_middleware import add_process_time_header
from app.middleware.label_middleware import add_request_id_header


def register_middlewares(app: FastAPI) -> None:
    # 确保 add_request_id_header 在最后一个添加，会第一个调用
    app.add_middleware(BaseHTTPMiddleware, dispatch=add_process_time_header)
    app.add_middleware(BaseHTTPMiddleware, dispatch=add_request_id_header)


__all__ = [
    "register_middlewares",
]
