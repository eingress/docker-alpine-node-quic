
include .env
export

SHELL := /bin/bash

IMAGE_VERSION = ${NODE_VERSION}

.PHONY: build push release

build:
	docker build --squash \
		--build-arg ALPINE_VERSION=$$ALPINE_VERSION \
		--build-arg NODE_VERSION=$$NODE_VERSION \
		--build-arg YARN_VERSION=$$YARN_VERSION \
		-t $$IMAGE_NAME:$$IMAGE_VERSION \
		-t $$IMAGE_NAME:latest \
		.

push:
	docker push --all-tags $$IMAGE_NAME

release: build push