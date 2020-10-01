DOCKER_REPO := eu.gcr.io
DOCKER_NAME := mlflow
DOCKER_TAG := 0.1


pre-requesites:
	@cd Iac/prerequesites && terraform init && terraform apply -var-file defaults.tfvars"

build-docker:
	@cd tracking_server && docker build -t $(DOCKER_REPO)/$(PROJECT_ID)/$(DOCKER_NAME):$(DOCKER_TAG) -f tracking.Dockerfile .

push-docker:
	@docker push $(DOCKER_REPO)/$(PROJECT_ID)/$(DOCKER_NAME):$(DOCKER_TAG)

init-terraform:
	@cd Iac && terraform init -backend-config="bucket=$(BACKEND_TERRAFORM)"

apply-terraform:
	@cd Iac && terraform apply -var-file defaults.tfvars -var="mlflow_docker_image=$(DOCKER_REPO)/$(PROJECT_ID)/$(DOCKER_NAME):$(DOCKER_TAG)"

plan-terraform:
	@cd Iac && terraform plan -var-file defaults.tfvars -var="mlflow_docker_image=$(DOCKER_REPO)/$(PROJECT_ID)/$(DOCKER_NAME):$(DOCKER_TAG)"

destroy-terraform:
	@cd Iac && terraform destroy -var-file defaults.tfvars -var="mlflow_docker_image=$(DOCKER_REPO)/$(PROJECT_ID)/$(DOCKER_NAME):$(DOCKER_TAG)"

apply: init-terraform apply-terraform

plan: init-terraform plan-terraform

destroy: init-terraform destroy-terraform

docker: build-docker push-docker
