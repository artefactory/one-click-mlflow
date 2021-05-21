# GNU Lesser General Public License v3.0 only
# Copyright (C) 2020 Artefact
# licence-information@artefact.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
terraform {
  required_version = "> 0.13.2"
  required_providers {
    google = "~> 3.13"
  }
}

provider "google" {
  project = var.project_id
}

module "services" {
  source     = "./../modules/services"
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
    "iap.googleapis.com",
    "cloudbuild.googleapis.com"
  ]
}

module "bucket_backend" {
  source             = "./../modules/mlflow/artifacts"
  bucket_name        = var.backend_bucket
  bucket_location    = var.backend_bucket_location
  number_of_version  = var.backend_bucket_number_of_version
  storage_class      = var.backend_bucket_storage_class
  storage_uniform    = var.storage_uniform
  versioning_enabled = var.tfstate_versionning
}