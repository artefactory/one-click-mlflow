pre-requesites:
	source vars_base && cd Iac/prerequesites && terraform init && terraform apply

docker:
	source vars_base && gcloud builds submit --tag $${TF_VAR_mlflow_docker_image} ./tracking_server

init-terraform:
	source vars_base && cd Iac && terraform init -backend-config="bucket=$${TF_VAR_backend_bucket}"

apply-terraform:
	source vars_base && cd Iac && terraform apply

plan-terraform:
	source vars_base && cd Iac && terraform plan

import-terraform:
	source vars_base && cd Iac && ./../bin/terraform_import.sh

destroy-terraform:
	source vars_base && cd Iac && terraform destroy

apply: init-terraform import-terraform apply-terraform

plan: init-terraform plan-terraform

destroy: init-terraform destroy-terraform

init: pre-requesites

deploy: docker apply

one-click-mlflow: init deploy

.PHONY: pre-requesites docker init-terraform apply-terraform plan-terraform import-terraform destroy-terraform
.PHONY: apply plan destroy docker init deploy one-click-mlflow