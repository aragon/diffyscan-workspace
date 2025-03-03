.DEFAULT_TARGET: help

# Import the .env files and export their values
include .env
include deployments.mk

SHELL:=/bin/bash
validate_deployment = $(if $(findstring $(1),$(AVAILABLE_DEPLOYMENTS)),,$(error "Invalid deployment target: $(1). The allowed deployment targets are: $(AVAILABLE_DEPLOYMENTS)"))
ensure_file = $(if $(wildcard $(1)),,$(error "Required file not found: $(1)"))
DIFFYSCAN_PARAMS_FILE = diffyscan-params.json

# TARGETS

.PHONY: help
help:
	@echo "Available targets:"
	@grep -E '^[a-zA-Z0-9_-]*:.*?## .*$$' Makefile \
		| sed -n 's/^\(.*\): \(.*\)##\(.*\)/- make \1  \3/p' \
		| sed 's/^- make    $$//g'
	@for dep in $(AVAILABLE_DEPLOYMENTS); do echo "- make $$dep    Verify using deployments/$$dep.json"; done

: ## 

.PHONY: init
init: .env ##     Check the dependencies and prepare the Docker image
	@which docker > /dev/null || (echo "Error: Docker is not installed" ; exit 1)
	@which jq > /dev/null || (echo "Error: jq is not installed" ; exit 1)
	docker build -t diffyscan .

.PHONY: clean
clean: ##    Clean the generated artifacts
	docker image rm diffyscan || true
	rm -Rf ./digest

: ## 

# Generate dynamic rules for each supported deployment:

# sepolia: export NETWORK=sepolia
# sepolia: export DEPLOYMENT_PARAMS_FILE=deployments/sepolia.json
# sepolia: check

$(foreach network,$(AVAILABLE_DEPLOYMENTS),\
    $(eval $(network): export NETWORK = $(network))\
    $(eval $(network): export DEPLOYMENT_PARAMS_FILE = deployments/$(network).json)\
    $(eval $(network): check)\
)

# Main target (hidden)
.PHONY: check
check: $(DIFFYSCAN_PARAMS_FILE)
	$(call validate_deployment,$(NETWORK))
	docker run --rm -it \
		-v ./.env:/workspace/.env:ro \
		-v ./$(DIFFYSCAN_PARAMS_FILE):/workspace/$(DIFFYSCAN_PARAMS_FILE):ro \
		-v ./digest:/workspace/digest \
		diffyscan $(DIFFYSCAN_PARAMS_FILE)

	@output_path="./digest/$$(ls -t digest/ | head -n 1)" ; \
	echo ; \
	echo "Checking the diffs on $$output_path" ; \
	list_diffs() { \
		cat $$output_path/logs.txt | \
			grep "^│" | \
			grep -v " │ 0     │ " | \
			grep -v "Filename" | \
			cut -d'│' -f3 | awk '{print $$1}' | sort | uniq ; \
	} ; \
	mismatches=$$(list_diffs | xargs echo) ; \
	if [ -z "$$mismatches" ] ; then exit; fi ; \
	echo -e -n "Files with differences:\n- " ; \
	echo $$mismatches ; \
	echo ; \
	diffs=$$(find $$output_path/diffs | grep -E "\b($$(echo $$mismatches | tr ' ' '|'))\b") ; \
	echo -n "Do you want to open them? (y/N) " ; read cont ; \
	[ "$$cont" == "y" ] && open $$diffs || true

# Generate the params file for diffyscan
.PHONY: $(DIFFYSCAN_PARAMS_FILE)
$(DIFFYSCAN_PARAMS_FILE):
	$(call ensure_file,$(DEPLOYMENT_PARAMS_FILE))
	@echo "Reading deployment parameters from $(DEPLOYMENT_PARAMS_FILE)"
	@echo "Merging 'explorer_token_env_var' onto $(@)"
	jq '.explorer_token_env_var = $(ETHERSCAN_EXPLORER_TOKEN)' $(DEPLOYMENT_PARAMS_FILE) > $(@)
