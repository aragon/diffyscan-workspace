.DEFAULT_TARGET: help

# Import the .env files and export their values (ignore any error if missing)
-include .env

# ADD NET NETWORKS HERE:
SUPPORTED_NETWORKS := sepolia holesky

SHELL:=/bin/bash
check_network = $(if $(findstring $(1),$(SUPPORTED_NETWORKS)),,$(error "Invalid network: $(1). Allowed networks are: $(SUPPORTED_NETWORKS)"))
check_file_exists = $(if $(wildcard $(1)),,$(error "Required file not found: $(1)"))
DIFFYSCAN_PARAMS_FILE = ./params/diffyscan.json

# TARGETS

.PHONY: help
help:
	@echo "Available targets:"
	@grep -E '^[a-zA-Z0-9_-]*:.*?## .*$$' Makefile \
		| sed -n 's/^\(.*\): \(.*\)##\(.*\)/- make \1  \3/p' \
		| sed 's/^- make    $$//g'
	@for nw in $(SUPPORTED_NETWORKS); do echo "- make check-$$nw    Check the deployment from params/$$nw-deployment.json"; done

: ## 

.PHONY: init
init: .env ##     Check the dependencies and prepare the Docker image
	@which docker > /dev/null || (echo "Error: Docker is not installed" ; exit 1)
	@which jq > /dev/null || (echo "Error: jq is not installed" ; exit 1)
	docker build -t diffyscan .

.PHONY: clean
clean: ##    Clean the generated artifacts
	docker image rm diffyscan || true

: ## 

# Generate dynamic rules for each supported network:

# check-sepolia: export NETWORK=sepolia
# check-sepolia: export DEPLOYMENT_PARAMS_FILE=params/sepolia-deployment.json
# check-sepolia: check

$(foreach network,$(SUPPORTED_NETWORKS),\
    $(eval check-$(network): export NETWORK = $(network))\
    $(eval check-$(network): export DEPLOYMENT_PARAMS_FILE = params/$(network)-deployment.json)\
    $(eval check-$(network): check)\
)

# Main target (hidden)
.PHONY: check
check: $(DIFFYSCAN_PARAMS_FILE)
	$(call check_network,$(NETWORK))
	docker run --rm -it \
		-v ./.env:/workspace/.env:ro \
		-v ./params/diffyscan.json:/workspace/params/diffyscan.json:ro \
		-v ./digest:/workspace/digest \
		diffyscan $(DIFFYSCAN_PARAMS_FILE)
	@echo "Check the diff outputs on ./digest/$$(ls -t digest/ | head -n 1)"

# Generate the params file for diffyscan
.PHONY: $(DIFFYSCAN_PARAMS_FILE)
$(DIFFYSCAN_PARAMS_FILE):
	$(call check_file_exists,$(DEPLOYMENT_PARAMS_FILE))
	@echo "Reading deployment parameters from $(DEPLOYMENT_PARAMS_FILE)"
	@echo "Merging 'explorer_token_env_var' onto $(@)"
	jq '.explorer_token_env_var = $(ETHERSCAN_EXPLORER_TOKEN)' $(DEPLOYMENT_PARAMS_FILE) > $(@)
