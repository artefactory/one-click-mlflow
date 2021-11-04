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
resource "google_storage_bucket" "this" {
  project       = var.project_id
  name          = var.bucket_name
  location      = var.bucket_location
  storage_class = var.storage_class
  versioning {
    enabled = var.versioning_enabled
  }
  lifecycle_rule {
    condition {
      num_newer_versions = var.number_of_version
    }
    action {
      type = "Delete"
    }
  }
  uniform_bucket_level_access = var.storage_uniform
  force_destroy               = true
}
