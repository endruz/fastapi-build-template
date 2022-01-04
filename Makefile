SHELL := /bin/bash

.EXPORT_ALL_VARIABLES:

ROOT_PATH := $(CURDIR)
MAIN_FILE := $(ROOT_PATH)/main.sh


define HELP_INFO
Usage:
	make <Target>

Target:
	check	check build env
	clean	cleanup build env
	build	build fastapi service template
	help	show this help info

Example:
	make check
	make clean
	make build
	make help
endef

.PHONY: help
help:
	@echo "$$HELP_INFO"

.PHONY: check
check:
	@$(MAIN_FILE) check

.PHONY: clean
clean:
	@$(MAIN_FILE) clean

.PHONY: build
build: check clean
	@$(MAIN_FILE) build
