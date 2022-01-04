#!/usr/bin/env python
# coding:utf-8

import uuid
from fastapi import Request

from app.config import request_id_context


async def add_request_id_header(request: Request, call_next):
    request_id = str(uuid.uuid4())
    request_id_context.set(request_id)
    response = await call_next(request)
    response.headers["X-Request-Id"] = request_id
    request_id_context.set(None)
    return response
