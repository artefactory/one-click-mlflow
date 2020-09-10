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


module "network" {
  source = "modules/network"
  vpc_name = var.network_name
}