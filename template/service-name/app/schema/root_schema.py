#!/usr/bin/env python
# coding:utf-8

from typing import List
from pydantic import BaseModel, Field

# Parameters model

# Responses model


class RootRes(BaseModel):
    Name: str = Field(
        ..., alias="service_name", title="服务名", description="服务名", example="ai-service"
    )
    Version: str = Field(
        ..., alias="version", title="版本号", description="服务版本号", example="v2.0"
    )
    Maintainer: List[str] = Field(
        ...,
        alias="maintainer",
        title="维护者",
        description="维护者信息: 姓名 <邮箱>",
        example=["zhangsan <zhangsan@email.com>"],
    )
