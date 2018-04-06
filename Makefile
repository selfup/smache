# set target to linux and amd64 for pretty much any 64bit linux
GO_BUILD_ENV := CGO_ENABLED=0 GOOS=linux GOARCH=amd64

# find working dir and point to docker_build dotfile
DOCKER_BUILD=$(shell pwd)/.docker_build
# add sub dir in .docker_build
DOCKER_CMD=$(DOCKER_BUILD)/mitigator

# clean prior to building
$(DOCKER_CMD): clean
	mkdir -p $(DOCKER_BUILD)
	$(GO_BUILD_ENV) go build -v -o $(DOCKER_CMD) ./mitigator

# define clean command
clean:
	rm -rf $(DOCKER_BUILD)
