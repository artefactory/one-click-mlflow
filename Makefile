pre-requesites:
	source vars_base && cd Iac/prerequesites && terraform init && terraform apply

docker:
	source vars_base && gcloud builds submit --tag $${TF_VAR_mlflow_docker_image} ./tracking_server

init-terraform:
	source vars_base && cd Iac && terraform init -backend-config="bucket=$${TF_VAR_backend_bucket}"

apply-terraform:
	source vars_base && cd Iac && terraform apply
apply-terraform-cicd:
	source vars_base && cd Iac && terraform apply -auto-approve

plan-terraform:
	source vars_base && cd Iac && terraform plan

import-terraform:
	source vars_base && cd Iac && ./../bin/terraform_import.sh

destroy-terraform:
	source vars_base && cd Iac && terraform destroy

apply: init-terraform import-terraform apply-terraform
apply-cicd: init-terraform import-terraform apply-terraform-cicd

plan: init-terraform plan-terraform

destroy: init-terraform destroy-terraform

init: pre-requesites

deploy: docker apply
deploy-cicd: docker apply-cicd

one-click-mlflow: init deploy
one-click-mlflow-cicd: init deploy-cicd

.PHONY: pre-requesites docker init-terraform apply-terraform apply-terraform-cicd plan-terraform import-terraform destroy-terraform
.PHONY: apply apply-cicd plan destroy docker init deploy deploy-cicd one-click-mlflow one-click-mlflow-cicd