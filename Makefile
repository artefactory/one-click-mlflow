pre-requesites:
	@cd Iac/prerequesites && terraform init && terraform apply -var="project_id=$(PROJECT_ID)"

build-docker:
	@cd tracking_server && docker build -t eu.gcr.io/$(PROJECT_ID)/mlflow:latest -f tracking.Dockerfile .

push-docker:
	@docker push eu.gcr.io/$(PROJECT_ID)/mlflow:latest

init-terraform:
	@cd Iac && terraform init -backend-config="bucket=$(BACKEND_TERRAFORM)"

apply-terraform:
	@cd Iac && terraform apply -var="project_id=$(PROJECT_ID)" -var="mlflow_docker_image=eu.gcr.io/$(PROJECT_ID)/mlflow:latest"

plan-terraform:
	@cd Iac && terraform plan -var="project_id=$(PROJECT_ID)" -var="mlflow_docker_image=eu.gcr.io/$(PROJECT_ID)/mlflow:latest"

destroy-terraform:
	@cd Iac && terraform destroy -var="project_id=$(PROJECT_ID)" -var="mlflow_docker_image=eu.gcr.io/$(PROJECT_ID)/mlflow:latest"

apply: init-terraform apply-terraform

plan: init-terraform plan-terraform

destroy: init-terraform destroy-terraform

docker: build-docker push-docker
