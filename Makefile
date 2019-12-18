.PHONY: all
.DEFAULT_GOAL := help
DOCKER_IMAGE=drone-deployer
VERSION_TAG=0.1.1

## help: Prints this help message
help:
	@echo "Commands available"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /' | sort

## ci-conf: Update CI/CD configuration file
ci-conf:
	drone lint .drone.yml
	@DRONE_SERVER=${BRYK_DRONE_SERVER} DRONE_TOKEN=${BRYK_DRONE_TOKEN} drone sign --save bryk-io/drone-deployer

## docker: Build docker image
docker:
	@-docker rmi ${DOCKER_IMAGE}:${VERSION_TAG}
	docker build -t ${DOCKER_IMAGE}:${VERSION_TAG} .
