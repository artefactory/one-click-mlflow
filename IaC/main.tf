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
}
