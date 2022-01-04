#!/usr/bin/env python
# coding:utf-8

import threading
from functools import wraps


def singleton(cls):
    _instances = {}
    _instance_lock = threading.Lock()

    @wraps(cls)
    def _singlenton(*args, **kargs):
        with _instance_lock:
            if cls not in _instances:
                _instances[cls] = cls(*args, **kargs)
        return _instances[cls]

    return _singlenton
