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
resource "google_service_account" "log_pusher" {
  account_id   = "mlflow-log-pusher"
  display_name = "mlflow log pusher"
}

resource "google_project_iam_member" "log_pusher_iap" {
  project = var.project_id
  role    = "roles/iap.httpsResourceAccessor"
  member = "serviceAccount:${google_service_account.log_pusher.email}"
}

resource "google_project_iam_member" "log_pusher_storage" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.log_pusher.email}"
}