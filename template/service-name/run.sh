#!/bin/bash

if [[ $IS_CLEANUP_TMP ]]; then
	sed -i "s/is_cleanup_tmp = True/is_cleanup_tmp = $IS_CLEANUP_TMP/g" app/config/cfg.py
fi

uvicorn main:app --host 0.0.0.0 --port 8080
