GO_BUILD_ENV := CGO_ENABLED=0 GOOS=linux GOARCH=amd64

DOCKER_BUILD=$(shell pwd)/.docker_build

DOCKER_CMD_MITIGATOR=$(DOCKER_BUILD)/mitigator
DOCKER_CMD_REGISTRY=$(DOCKER_BUILD)/registry

main:
	rm -rf $(DOCKER_BUILD)
	mkdir -p $(DOCKER_BUILD)
	$(GO_BUILD_ENV) go build -v -o $(DOCKER_CMD_MITIGATOR) ./mitigator
	$(GO_BUILD_ENV) go build -v -o $(DOCKER_CMD_REGISTRY) ./registry
