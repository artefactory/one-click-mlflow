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
variable "artifacts_bucket_name" {
  description = "Name of the mlflow bucket created to store artifacts"
  type        = string
}
variable "artifacts_bucket_location" {
  description = "Location of the mlflow artifact bucket deployed"
  type        = string
  default     = "EUROPE-WEST1"
}
variable "artifacts_number_of_version" {
  description = "Number of file version kept in your artifacts bucket"
  type        = number
  default     = 1
}
variable "artifacts_storage_class" {
  description = "Storage class of your artifact bucket"
  type        = string
  default     = "STANDARD"
}
variable "db_password_name" {
  description = "Name of the database password stored in secret manager"
  type        = string
  default     = "mlflow-db-pwd"
}
variable "db_password_value" {
  description = "Value of the database password stored in secret manager"
  type        = string
}
variable "db_username" {
  description = "Value of the database username"
  type        = string
  default     = "mlflowuser"
}
variable "db_instance_prefix" {
  description = "prefix used as database instance name"
  type        = string
  default     = "mlflow"
}
variable "db_version" {
  description = "Database instance version in GCP"
  type        = string
  default     = "MYSQL_5_7"
}
variable "db_region" {
  description = "Database region"
  type        = string
  default     = "europe-west1"
}
variable "db_size" {
  description = "Database instance size"
  type        = string
  default     = "db-f1-micro"
}
variable "db_availability_type" {
  description = "Availability of your database"
  type        = string
  default     = "ZONAL"
}
variable "db_name" {
  description = "Name of the database created inside the instance"
  type        = string
  default     = "mlflow"
}
variable "create_default_service" {
  description = "Whether or not to create a default app engine service"
  type = bool
}
variable "mlflow_server" {
  description = "Name of the mlflow server deployed to app engine. If a service already have this name, it will be overwritten."
  type        = string
}
variable "server_location" {
  description = "Location to deploy cloud run server"
  type        = string
  default     = "europe-west"
}
variable "server_docker_image" {
  description = "Docker image name of your mlflow server"
  type        = string
}
variable "server_env_variables" {
  description = "Env variables used inside your container"
  type        = map
  default     = {}
}
variable "project_id" {
  description = "GCP project"
  type        = string
}
variable "module_depends_on" {
  type    = any
  default = null
}
variable "consent_screen_support_email" {
  type        = string
  description = "Person or group to contact in case of problem"
}
variable "web_app_users" {
  type        = list(string)
  description = "List of people who can acess the mlflow web app. e.g. [user:jane@example.com, group:people@example.com]"
}
variable "network_self_link" {
  type = string
}
variable "network_short_name" {}
variable "oauth_client_id" {
  type        = string
  description = "Oauth client id, empty if consent screen not set up"
}
variable "oauth_client_secret" {
  type        = string
  description = "Oauth client secret, empty if consent screen not set up"
}
