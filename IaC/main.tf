terraform {
  backend "gcs" {
  }
  required_version = "=0.13.2"
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

resource "random_id" "artifacts_bucket_name_suffix" {
  byte_length = 5
}

module "network" {
  source = "./modules/network"
}

module "mlflow" {
  source = "./modules/mlflow"
  artifacts_bucket_name = "${var.artifacts_bucket}-${random_id.artifacts_bucket_name_suffix.hex}"
  db_password_value = var.db_password_value
  server_docker_image = var.mlflow_docker_image
  project_id = var.project_id
  consent_screen_support_email = var.consent_screen_support_email
  web_app_users = var.web_app_users
}
