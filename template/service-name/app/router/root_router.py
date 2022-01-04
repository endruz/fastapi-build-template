#!/usr/bin/env python
# coding:utf-8

from fastapi import APIRouter

from app.config import cfg
from app.schema.root_schema import RootRes

root_router = APIRouter()


@root_router.get(path="/", response_model=RootRes, summary="服务信息接口")
async def welcome():
    return cfg.__dict__
