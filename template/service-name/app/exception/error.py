#!/usr/bin/env python
# coding:utf-8

from fastapi import status


def generate_exception(
    exception_name: str, status_code: int, error_code: int, message: str
):
    """
    动态创建异常类的方法
    """
    return type(
        exception_name,
        (Exception,),
        {"status_code": status_code, "error_code": error_code, "message": message},
    )


FileTypeError = generate_exception(
    "FileTypeError", status.HTTP_400_BAD_REQUEST, 1001, "文件类型错误!"
)
