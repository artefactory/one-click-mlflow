pre-requesites: 
	@cd Iac/prerequesites && terraform init && terraform apply

init-terraform:
	@cd Iac && terraform init -backend-config="bucket=$(BACKEND_TERRAFORM)"

apply-terraform:
	@cd Iac && terraform apply -var="project_id=$(PROJECT_ID)" -var="mlflow_docker_image=eu.gcr.io/$(PROJECT_ID)/mlflow:latest"

plan-terraform:
	@cd Iac && terraform plan -var="project_id=$(PROJECT_ID)" -var="mlflow_docker_image=eu.gcr.io/$(PROJECT_ID)/mlflow:latest"

destroy-terraform:
	@cd Iac && terraform destroy -var="project_id=$(PROJECT_ID)" -var="mlflow_docker_image=eu.gcr.io/$(PROJECT_ID)/mlflow:latest"

apply: pre-check init-terraform apply-terraform

plan: pre-check init-terraform plan-terraform

destroy: pre-check init-terraform destroy-terraform