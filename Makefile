ifeq ($(SHELL),/bin/sh)
	SHELL:=/bin/bash
endif
pre-requesites:
	source vars_base && cd IaC/prerequesites && terraform init && terraform apply

build-docker:
	source vars_base && cd tracking_server && docker build -t $${TF_VAR_mlflow_docker_image} -f tracking.Dockerfile .

push-docker:
	source vars_base && docker push $${TF_VAR_mlflow_docker_image}

init-terraform:
	source vars_base && cd IaC && terraform init -backend-config="bucket=$${TF_VAR_backend_bucket}"

apply-terraform:
	source vars_base && cd IaC && terraform apply

plan-terraform:
	source vars_base && cd IaC && terraform plan

destroy-terraform:
	source vars_base && cd IaC && terraform destroy

apply: init-terraform apply-terraform

plan: init-terraform plan-terraform

destroy: init-terraform destroy-terraform

docker: build-docker push-docker

init: pre-requesites

deploy: docker apply

one-click-mlflow : init deploy
