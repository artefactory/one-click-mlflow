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
    type = string
}
variable "backend_bucket" {
    description = "Name of the bucket."
    type        = string
}
variable "backend_bucket_location" {
    description = "Location of the bucket."
    type        = string
    default     = "EUROPE-WEST1"
}
variable "versioning_enabled" {
    description = "True if you want to version your bucket."
    type        = bool
    default     = true
}
variable "backend_bucket_number_of_version" {
    description = "Number of version you want to keep with the versionning."
    type        = number
    default     = 3
}
variable "backend_bucket_storage_class" {
    description = "Storage class of your bucket"
    type        = string
    default     ="STANDARD"
}
variable "storage_uniform" {
    type = bool
    description = "Wether or not uniform level acces is to be activated for the buckets"
    default = true
}
variable "tfstate_versionning" {
    type = bool
    description = "Wether or not the remote TFstate should be versioned"
    default = true
}