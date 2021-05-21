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
resource "random_id" "db_name_suffix" {
  byte_length = 5
}

resource "google_sql_database_instance" "this_instance" {
  name             = "${var.instance_prefix}-${random_id.db_name_suffix.hex}"
  database_version = var.database_version
  region           = var.region

  settings {
    tier = var.size
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_self_link
    }
    backup_configuration {
      enabled = true
    }
    availability_type = var.availability_type
  }
  deletion_protection = false
}

resource "google_sql_database" "this_database" {
  name       = var.database_name
  instance   = google_sql_database_instance.this_instance.name
  depends_on = [google_sql_database_instance.this_instance]
}

resource "google_sql_user" "this_user" {
  name       = var.username
  instance   = google_sql_database_instance.this_instance.name
  password   = var.password
  depends_on = [google_sql_database_instance.this_instance]
}
