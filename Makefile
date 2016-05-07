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
	cd "$(BASE)/src" && docker build -t $(CONTAINER) .

run:
	# __$(shell date +'%Y-%m-%d_T%H-%M-%S')
	cd "$(BASE)/src" && docker run \
		--name "$(CONTAINER)" \
		-p 2022:22 \
		-i -t \
		"$(CONTAINER)"

tar:
	cd "$(BASE)/../" && tar --exclude="./$(DIRNAME)/env" -czvf $(DIRNAME)-$(NOW).tgz ./$(DIRNAME)
	cd "$(BASE)" && ls -lahtr "$(BASE)/../$(DIRNAME)-"* | tail -n1


