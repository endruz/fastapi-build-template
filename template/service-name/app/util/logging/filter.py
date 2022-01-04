#!/usr/bin/env python
# coding:utf-8

from logging import Filter

from app.config import request_id_context


class TraceIDFilter(Filter):
    def filter(self, record):
        record.traceid = request_id_context.get("TRACE_ID")
        return True
