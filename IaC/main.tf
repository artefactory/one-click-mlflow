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
