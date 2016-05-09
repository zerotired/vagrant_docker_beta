# pansen docker `Makefile`

CONTAINER := amb_jessie
DOCKER_MACHINE := $(shell docker ps -a -q)

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
		--privileged \
		-p 2022:6022 \
		-p 2023:22 \
		-v "$(BASE)/srv:/srv" \
		-i -t -d \
		"$(CONTAINER)"
	docker ps

# http://sosedoff.com/2013/12/17/cleanup-docker-containers-and-images.html
reset:
	docker stop "$(CONTAINER)" $(DOCKER_MACHINE)
	docker rm -f $(DOCKER_MACHINE)
	docker rmi -f "$(CONTAINER)"

ssh.docker:
	ssh vagrant@127.0.0.1 -o "Port 2022" \
		-o "IdentityFile $(BASE)/src/ssh/.vagrant.d/insecure_private_key" \
		-o "UserKnownHostsFile /dev/null" \
		-o "StrictHostKeyChecking no"

ssh.vagrant:
	ssh vagrant@127.0.0.1 -o "Port 2023" \
		-o "IdentityFile $(BASE)/src/ssh/.vagrant.d/insecure_private_key" \
		-o "UserKnownHostsFile /dev/null" \
		-o "StrictHostKeyChecking no"

tar:
	cd "$(BASE)/../" && tar --exclude="./$(DIRNAME)/env" -czvf $(DIRNAME)-$(NOW).tgz ./$(DIRNAME)
	cd "$(BASE)" && ls -lahtr "$(BASE)/../$(DIRNAME)-"* | tail -n1
