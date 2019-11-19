.PHONY: all
.DEFAULT_GOAL := help
REPO=registry.bryk.io/base/drone-deployer

ci-config: ## Format and sign the CI pipeline configuration
	drone fmt --save
	DRONE_SERVER=${BRYK_DRONE_SERVER} \
	DRONE_TOKEN=${BRYK_DRONE_TOKEN} \
	drone sign --save bryk-io/drone-deployer

build: ## Build the docker image for the ployer using the provided version="" tag
	@-docker rmi ${REPO}:$(version)
	docker build -t ${REPO}:$(version) .

publish: ## Upload a specific version="" to the designated registry
	docker push ${REPO}:$(version)

help: ## Display available make targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[33m%-16s\033[0m %s\n", $$1, $$2}'
