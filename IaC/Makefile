

pre-check: 
	-gsutil -m mb -l EU -p $(PROJECT_ID) gs://$(BACKEND_TERRAFORM)

init-terraform:
	@terraform init -backend-config="bucket=$(BACKEND_TERRAFORM)" 

apply-terraform:
	@terraform apply --quiet -var="project_id=$(PROJECT_ID)"

plan-terraform:
	@terraform plan -var="project_id=$(PROJECT_ID)"

apply: pre-check init-terraform apply-terraform

plan: pre-check init-terraform plan-terraform
