#!/usr/bin/env python
# coding:utf-8

import os

service_name = "@SERVICE_NAME@"
version = "@VERSION@"
maintainer = @MAINTAINER@
tmp_path = "./tmp"
is_cleanup_tmp = os.getenv("IS_CLEANUP_TMP", "True") == "True"
