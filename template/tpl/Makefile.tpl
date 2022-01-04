SHELL := /bin/bash

.EXPORT_ALL_VARIABLES:

ROOT_PATH := $(CURDIR)
SRC_PATH := $(CURDIR)/@SERVICE_NAME@
LIB_PATH := $(CURDIR)/lib
BUILD_PATH := $(CURDIR)/build

define HELP_INFO
Usage:
	make <Target>

Target:
	init            init the dev env
	clean           cleanup service env
	lint            check python code
	format          format python code
	build           build service env
	start           startup service
	build-docker    build docker image
	start-docker    run docker container
	help            show this help info

Example:
	make init
	make clean
	make lint
	make format
	make build
	make start
	make build-docker
	make start-docker
	make help
endef


.PHONY: help
help:
	@echo "$$HELP_INFO"

.PHONY: init
init:
	@echo "start to init ..."
	$(BUILD_PATH)/lib/build.sh
	pip install -r $(ROOT_PATH)/requirements_dev.txt

.PHONY: clean
clean:
	@echo "start to cleanup ..."
	find $(SRC_PATH) -name "__pycache__" -type d | xargs rm -rf

.PHONY: lint
lint:
	@echo "start to lint ..."
	flake8 $(SRC_PATH)

.PHONY: format
format:
	@echo "start to format ..."
	black $(SRC_PATH)

.PHONY: build
build:
	@echo "start to build service env ..."
	$(BUILD_PATH)/lib/build.sh

.PHONY: start
start: clean
	@echo "start to startup service ..."
	cd $(SRC_PATH) && ./run.sh

.PHONY: build-docker
build-docker: clean
	@echo "start to build docker ..."
	$(BUILD_PATH)/lib/build_image.sh

.PHONY: start-docker
start-docker:
	@echo "start to run docker ..."
	$(BUILD_PATH)/lib/run_container.sh
