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

module "artifacts" {
  source            = "./artifacts"
  bucket_name       = var.artifacts_bucket_name
  bucket_location   = var.artifacts_bucket_location
  project_id        = var.project_id
  number_of_version = var.artifacts_number_of_version
  storage_class     = var.artifacts_storage_class
}

module "db_secret" {
  source       = "./secret_manager"
  project_id   = var.project_id
  secret_id    = var.db_password_name
}

module "database" {
  source            = "./database"
  project_id        = var.project_id
  instance_prefix   = var.db_instance_prefix
  database_version  = var.db_version
  region            = var.db_region
  size              = var.db_size
  availability_type = var.db_availability_type
  database_name     = var.db_name
  username          = var.db_username
  password          = module.db_secret.secret_value
  network_self_link = var.network_self_link
}

module "server" {
  source                       = "./server"
  mlflow_server                = var.mlflow_server
  create_default_service       = var.create_default_service
  location                     = var.server_location
  docker_image_name            = var.server_docker_image
  env_variables                = var.server_env_variables
  db_private_ip                = module.database.private_ip
  project_id                   = var.project_id
  db_password_name             = var.db_password_name
  db_username                  = var.db_username
  db_name                      = var.db_name
  db_instance                  = module.database.instance_connection_name
  gcs_backend                  = module.artifacts.url
  module_depends_on            = var.module_depends_on
  consent_screen_support_email = var.consent_screen_support_email
  web_app_users                = var.web_app_users
  network_short_name           = var.network_short_name
  oauth_client_id              = var.oauth_client_id
  oauth_client_secret          = var.oauth_client_secret
  create_brand                 = var.create_brand
  brand_name                   = var.brand_name
}
