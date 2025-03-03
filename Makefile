.DEFAULT_TARGET: help

# Import the .env files and export their values (ignore any error if missing)
-include .env

# ADD NET NETWORKS HERE:
SUPPORTED_NETWORKS := sepolia holesky

SHELL:=/bin/bash
check_network = $(if $(findstring $(1),$(SUPPORTED_NETWORKS)),,$(error "Invalid network: $(1). Allowed networks are: $(SUPPORTED_NETWORKS)"))
check_file_exists = $(if $(wildcard $(1)),,$(error "Required file not found: $(1)"))

# TARGETS

.PHONY: help
help:
	@echo "Available targets:"
	@cat Makefile networks.mk | grep -E '^[a-zA-Z0-9_-]*:.*?## .*$$' \
		| sed -n 's/^\(.*\): \(.*\)##\(.*\)/- make \1  \3/p' \
		| sed 's/^- make    $$//g'
	@for nw in $(SUPPORTED_NETWORKS); do echo "- make $$nw    Check the deployment from params/$$nw-deployment.json"; done

: ## 

.PHONY: init
init: .env ##     Check the dependencies and prepare the Docker image
	@which docker > /dev/null || (echo "Error: Docker is not installed" ; exit 1)
	docker build -t diffyscan .

.PHONY: clean
clean: ##    Clean the generated artifacts
	docker image rm diffyscan || true

: ## 

# Generate dynamic rules for each supported network:

# check-sepolia: export NETWORK=sepolia
# check-sepolia: export PARAMS_FILE=params/sepolia-deployment.json
# check-sepolia: check

$(foreach network,$(SUPPORTED_NETWORKS),\
    $(eval check-$(network): export NETWORK = $(network))\
    $(eval check-$(network): export PARAMS_FILE = params/$(network)-deployment.json)\
    $(eval check-$(network): check)\
)

# Main target (hidden)
.PHONY: check
check:
	$(call check_network,$(NETWORK))
	$(call check_file_exists,$(PARAMS_FILE))
	docker run --rm -it -v .:/app/ diffyscan $(PARAMS_FILE)
