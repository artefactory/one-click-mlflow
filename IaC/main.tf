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
  backend "gcs" {
  }
  required_version = "> 0.13.2"
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
  source       = "./modules/network"
  network_name = var.network_name
}

module "mlflow" {
  source                       = "./modules/mlflow"
  mlflow_server                = var.mlflow_server
  artifacts_bucket_name        = "${var.artifacts_bucket}-${random_id.artifacts_bucket_name_suffix.hex}"
  db_password_value            = var.db_password_value
  server_docker_image          = var.mlflow_docker_image
  project_id                   = var.project_id
  consent_screen_support_email = var.consent_screen_support_email
  web_app_users                = var.web_app_users
  network_self_link            = module.network.network_self_link
  network_short_name           = module.network.network_short_name
  create_default_service       = var.create_default_service == 1 ? true : false
  oauth_client_id              = var.oauth_client_id
  oauth_client_secret          = var.oauth_client_secret
  brand_exists                 = var.brand_exists
  brand_name                   = var.brand_name
}

module "log_pusher" {
  source     = "./modules/mlflow/log_pusher"
  project_id = var.project_id
  depends_on = [module.mlflow]
}
