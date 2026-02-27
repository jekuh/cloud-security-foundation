SHELL := /bin/bash
TF ?= terraform
ENV ?= dev
ENV_DIR := envs/$(ENV)

AWS_REGION ?= eu-central-1
STATE_BUCKET ?= mb-terraform-state-2026
LOCK_TABLE ?= terraform-locks

.PHONY: fmt init validate plan apply destroy output tflint tfsec pr-check clean bootstrap-state bootstrap-oidc

fmt:
	$(TF) fmt -recursive

init:
	cd $(ENV_DIR) && $(TF) init -backend-config=backend.hcl

validate:
	cd $(ENV_DIR) && $(TF) validate

plan:
	cd $(ENV_DIR) && $(TF) plan

apply:
	cd $(ENV_DIR) && $(TF) apply

destroy:
	cd $(ENV_DIR) && $(TF) destroy

output:
	cd $(ENV_DIR) && $(TF) output

tflint:
	@command -v tflint >/dev/null 2>&1 || { echo "❌ tflint not installed. Run: brew install tflint"; exit 1; }
	cd . && tflint --init
	cd . && tflint -f compact

tfsec:
	@command -v tfsec >/dev/null 2>&1 || { echo "❌ tfsec not installed. Run: brew install tfsec"; exit 1; }
	tfsec .

pr-check: fmt init validate tflint tfsec plan

clean:
	find . -type d -name ".terraform" -prune -exec rm -rf {} \;
	find . -type f -name ".terraform.lock.hcl" -delete

bootstrap-state:
	@if [ -z "$(STATE_BUCKET)" ]; then echo "STATE_BUCKET is required"; exit 1; fi
	cd bootstrap/state && $(TF) init
	cd bootstrap/state && $(TF) apply -auto-approve \
		-var="aws_region=$(AWS_REGION)" \
		-var="state_bucket_name=$(STATE_BUCKET)" \
		-var="lock_table_name=$(LOCK_TABLE)"

bootstrap-oidc:
	@if [ -z "$(GITHUB_ORG)" ]; then echo "GITHUB_ORG is required"; exit 1; fi
	@if [ -z "$(GITHUB_REPO)" ]; then echo "GITHUB_REPO is required"; exit 1; fi
	@if [ -z "$(STATE_BUCKET)" ]; then echo "STATE_BUCKET is required"; exit 1; fi
	cd bootstrap/oidc && $(TF) init
	cd bootstrap/oidc && $(TF) apply -auto-approve \
		-var="aws_region=$(AWS_REGION)" \
		-var="github_org=$(GITHUB_ORG)" \
		-var="github_repo=$(GITHUB_REPO)" \
		-var="state_bucket_name=$(STATE_BUCKET)" \
		-var="lock_table_name=$(LOCK_TABLE)"
