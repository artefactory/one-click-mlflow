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
variable "project_id" {
  description = "GCP project"
  type        = string
}
variable "artifacts_bucket" {
  description = "GCS bucket used to store your artifacts"
  type        = string
  default     = "oneclick-mlflow-store"
}
variable "db_password_value" {
  description = "Database password to connect to your instance"
  type        = string
}
variable "mlflow_docker_image" {
  description = "Docker image used in container registry"
  type        = string
}
variable "consent_screen_support_email" {
  type        = string
  description = "Person or group to contact in case of problem (address shown in the OAuth consent screen)"
}
variable "web_app_users" {
  type        = list(string)
  description = "List of people who can acess the mlflow web app. e.g. [user:jane@example.com, group:people@example.com]"
}
variable "network_name" {
  type        = string
  description = "Name of the network to attach to. If empty, a new network will be created"
}
variable "storage_uniform" {
  type        = bool
  description = "Wether or not uniform level acces is to be activated for the buckets"
  default     = true
}