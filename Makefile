pre-requesites:
	source vars_base && cd Iac/prerequesites && terraform init && terraform apply
pre-requesites-cicd:
	source vars_base && cd Iac/prerequesites && terraform init && terraform apply -auto-approve

docker:
	source vars_base && gcloud builds submit --tag $${TF_VAR_mlflow_docker_image} ./tracking_server

init-terraform:
	source vars_base && cd Iac && rm -rf .terraform && terraform init -backend-config="bucket=$${TF_VAR_backend_bucket}"

apply-terraform:
	source vars_base && cd Iac && terraform apply
apply-terraform-cicd:
	source vars_base && cd Iac && terraform apply -auto-approve

plan-terraform:
	source vars_base && cd Iac && terraform plan

import-terraform:
	source vars_base && cd Iac && ./../bin/terraform_import.sh

gae-check:
	source vars_base && cd Iac && ./../bin/app_engine_check.sh

destroy-terraform:
	source vars_base && cd Iac && terraform destroy

setup-new-project:
	rm -rf .terraform vars_additionnal && cd Iac && rm -rf .terraform && rm -rf .terraform.lock.hcl && rm -rf prerequesites/.terraform && rm -rf prerequesites/.terraform.lock.hcl && rm -rf prerequesites/terraform.tfstate && rm -rf prerequesites/terraform.tfstate.backup
	source vars && gcloud config set project $${TF_VAR_project_id} && gcloud auth login && gcloud auth application-default login

apply: init-terraform gae-check import-terraform apply-terraform
apply-cicd: init-terraform gae-check import-terraform apply-terraform-cicd

plan: init-terraform plan-terraform

destroy: init-terraform destroy-terraform

init: pre-requesites
init-cicd: pre-requesites-cicd

deploy: docker apply
deploy-cicd: docker apply-cicd

one-click-mlflow: init deploy
one-click-mlflow-cicd: init-cicd deploy-cicd

.PHONY: pre-requesites pre-requesites-cicd docker init-terraform apply-terraform apply-terraform-cicd plan-terraform import-terraform destroy-terraform
.PHONY: apply apply-cicd plan destroy docker init init-cicd deploy deploy-cicd one-click-mlflow one-click-mlflow-cicd