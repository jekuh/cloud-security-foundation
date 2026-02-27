SHELL := /bin/bash
TF ?= terraform
ENV ?= dev
ENV_DIR := envs/$(ENV)

.PHONY: fmt init validate plan apply destroy output

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
