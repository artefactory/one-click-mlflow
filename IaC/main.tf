terraform {
  backend "gcs" {
  }
  required_version = "=0.12.29"
  required_providers {
    google = "~> 3.13"
  }
}

provider "google" {
  project = var.project_id
}

provider "google-beta" {
  project = var.project_id
}

module "services" {
  source = "./modules/services"
  project_id = var.project_id
  services = ["container.googleapis.com", "servicenetworking.googleapis.com", 
              "stackdriver.googleapis.com", "vpcaccess.googleapis.com", "run.googleapis.com",
              "sqladmin.googleapis.com", "iap.googleapis.com", "secretmanager.googleapis.com"]
}

resource "null_resource" "docker" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOT
      cd ../tracking_server && docker build -t eu.gcr.io/${var.project_id}/mlflow:latest -f tracking.Dockerfile .
      docker push eu.gcr.io/${var.project_id}/mlflow:latest
    EOT
  }
  depends_on = [module.services]
}

module "network" {
  source = "./modules/network"
  vpc_name = var.network_name
}

module "mlflow" {
  source = "./modules/mlflow"
  artifacts_bucket_name = var.artifacts_bucket
  db_password_value = var.db_password_value
  private_vpc_connection = module.network.private_vpc_connection
  network_link = module.network.network_link
  server_docker_image = var.mlflow_docker_image
  project_id = var.project_id
  vpc_connector = module.network.vpc_connector
  module_depends_on = null_resource.docker
}