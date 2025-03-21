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
help: ## Display the current message
	@echo "Available targets:"
	@cat Makefile | while IFS= read -r line; do \
	   if [[ "$$line" == "##" ]]; then \
			echo "" ; \
		elif [[ "$$line" =~ ^([^:]+):(.*)##\ (.*)$$ ]]; then \
			echo -e "- make $${BASH_REMATCH[1]}    \t$${BASH_REMATCH[3]}" ; \
		fi ; \
	done
	@for dep in $(AVAILABLE_DEPLOYMENTS); do \
	    if [ ! -z "$$dep" ]; then \
			echo -e "- make $$dep\t    Verify using deployments/$$dep.json"; \
		else echo "" ; \
		fi \
	done

##

.PHONY: init
init: .env ##            Check the dependencies and prepare the Docker image
	@which docker > /dev/null || (echo "Error: Docker is not installed" ; exit 1)
	@which jq > /dev/null || (echo "Error: jq is not installed" ; exit 1)
	docker build -t diffyscan .

.PHONY: clean
clean: ##           Clean the generated artifacts
	rm $(DIFFYSCAN_PARAMS_FILE)
	rm -Rf ./digest
	@#docker image rm diffyscan || true

.PHONY: diff-summary
diff-summary: ##    Show the detected mismatches on the latest run under ./digest
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
	echo $$diffs | (while read f ; do echo -e "- $$f\n" ; done) ; \
	echo -n "Do you want to open them? (y/N) " ; read cont ; \
	[ "$$cont" == "y" ] && open $$diffs || true

##

# Generate dynamic rules for each supported deployment:

# sepolia: export DEPLOYMENT=osx-sepolia
# sepolia: export DEPLOYMENT_PARAMS_FILE=deployments/osx-sepolia.json
# sepolia: check

$(foreach deployment,$(AVAILABLE_DEPLOYMENTS),\
    $(eval $(deployment): export DEPLOYMENT = $(deployment))\
    $(eval $(deployment): export DEPLOYMENT_PARAMS_FILE = deployments/$(deployment).json)\
    $(eval $(deployment): check)\
)

## INTERNAL TARGETS

# Main target
.PHONY: check
check: $(DIFFYSCAN_PARAMS_FILE)
	$(call validate_deployment,$(DEPLOYMENT))
	@# Launch Docker. Output a new line to make Python continue after each contract is checked
	yes "" | head -n $$(jq ".contracts | length" $(DIFFYSCAN_PARAMS_FILE)) | \
	   docker run --rm -i \
		-v ./.env:/workspace/.env:ro \
		-v ./$(DIFFYSCAN_PARAMS_FILE):/workspace/$(DIFFYSCAN_PARAMS_FILE):ro \
		-v ./digest:/workspace/digest \
		diffyscan

	make diff-summary

# Generate the params file for diffyscan
.PHONY: $(DIFFYSCAN_PARAMS_FILE)
$(DIFFYSCAN_PARAMS_FILE):
	$(call ensure_file,$(DEPLOYMENT_PARAMS_FILE))
	@echo "Reading deployment parameters from $(DEPLOYMENT_PARAMS_FILE)"
	@echo "Merging 'explorer_token_env_var' onto $(@)"
	jq '.explorer_token_env_var = $(BLOCK_EXPLORER_API_KEY)' $(DEPLOYMENT_PARAMS_FILE) > $(@)
