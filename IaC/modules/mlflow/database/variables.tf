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
variable "instance_prefix" {
  type        = string
  description = "Name of the database instance you want to deploy"
  default     = "mlflow"
}
variable "database_version" {
  type        = string
  description = "Version of the database instance you use"
  default     = "MYSQL_5_7"
}
variable "region" {
  type        = string
  description = "Region of the database instance"
}
variable "size" {
  type        = string
  description = "Size of the database instance"
  default     = "db-f1-micro"
}
variable "availability_type" {
  type        = string
  description = "Availability of your instance"
  default     = "ZONAL"
}
variable "database_name" {
  type        = string
  description = "Name of the database created"
  default     = "mlflow"
}
variable "username" {
  type        = string
  description = "Username to connect to database instance"
}
variable "password" {
  type        = string
  description = "Password to connect to database instance"
}
variable "module_depends_on" {
  type    = any
  default = null
}

variable "network_self_link" {
  type = string
}
