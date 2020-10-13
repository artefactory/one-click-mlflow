terraform {
  required_version = "~> 0.13.2"
  required_providers {
    google = "~> 3.13"
  }
}

provider "google" {
  project = var.project_id
}

module "services" {
  source = "./../modules/services"
  project_id = var.project_id
  services = [
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "servicenetworking.googleapis.com",
    "stackdriver.googleapis.com",
    "appengine.googleapis.com",
    "appengineflex.googleapis.com",
    "sqladmin.googleapis.com",
    "secretmanager.googleapis.com",
    "iap.googleapis.com"
  ]
}

module "bucket_backend" {
    source = "./../modules/mlflow/artifacts"
    bucket_name = var.backend_bucket
    bucket_location = var.backend_bucket_location
    number_of_version = var.backend_bucket_number_of_version
    storage_class = var.backend_bucket_storage_class
    storage_uniform = var.storage_uniform
    versioning_enabled = var.tfstate_versionning
}