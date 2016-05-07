# pansen docker `Makefile`

CONTAINER := amb_jessie

.DEFAULT_GOAL := all

# auto vars
# ---------
SHELL := /bin/bash
export BASE := $(shell /bin/pwd)
export DIRNAME := $(shell basename "$$(/bin/pwd)")
export PATH := $(PATH):$(BASE)/$(VIRTUALENV_DIR)/bin
export PYTHONUNBUFFERED := 1


build:
	cd "$(BASE)/src" && docker build \
		-t $(CONTAINER) \
		--rm=true \
		.

run:
	# __$(shell date +'%Y-%m-%d_T%H-%M-%S')
	cd "$(BASE)/src" && docker run \
		--name "$(CONTAINER)" \
		-p 2022:22 \
		-i -t -d \
		"$(CONTAINER)"
	docker ps

# http://sosedoff.com/2013/12/17/cleanup-docker-containers-and-images.html
reset:
	docker stop $(docker ps -a -q)
	docker rm -f $(docker ps -a -q)
	docker rmi -f $(docker images -a -q)

tar:
	cd "$(BASE)/../" && tar --exclude="./$(DIRNAME)/env" -czvf $(DIRNAME)-$(NOW).tgz ./$(DIRNAME)
	cd "$(BASE)" && ls -lahtr "$(BASE)/../$(DIRNAME)-"* | tail -n1


