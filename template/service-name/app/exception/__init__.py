#!/usr/bin/env python
# coding:utf-8

import traceback
from fastapi import status
from fastapi import Request
from fastapi import FastAPI
from starlette.responses import JSONResponse

from app.util import Logger
from app.exception import error
from app.config import request_id_context

logger = Logger()


async def custom_exception_handler(request: Request, exc: Exception) -> JSONResponse:
    logger.error(f"{request.method} {request.url} ERROR: {traceback.format_exc()}")
    if not getattr(exc, "error_code", None):
        return JSONResponse(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            content={"error_code": 1000, "message": "服务器内部错误!"},
            headers={"X-Request-Id": request_id_context.get()},
        )
    return JSONResponse(
        status_code=exc.status_code,
        content={"error_code": exc.error_code, "message": exc.message},
        headers={"X-Request-Id": request_id_context.get()},
    )


def register_exceptions(app: FastAPI) -> None:
    app.exception_handler(Exception)(custom_exception_handler)


__all__ = [
    "register_exceptions",
    "error",
]
