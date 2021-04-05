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
locals {
  env_variables = merge(
    {
      "GCP_PROJECT"      = var.project_id,
      "DB_PASSWORD_NAME" = var.db_password_name,
      "DB_USERNAME"      = var.db_username,
      "DB_NAME"          = var.db_name,
      "DB_PRIVATE_IP"    = var.db_private_ip,
      "GCS_BACKEND"      = var.gcs_backend
  }, var.env_variables)
}

data "google_project" "project" {
}

resource "google_app_engine_application" "app" {
  location_id = var.location
  iap {
    enabled              = true
    oauth2_client_id     = var.oauth_client_id != "" ? var.oauth_client_id : google_iap_client.project_client[0].client_id
    oauth2_client_secret = var.oauth_client_secret != "" ? var.oauth_client_secret : google_iap_client.project_client[0].secret
  }
}

resource "google_project_iam_member" "cloudsql" {
  depends_on = [google_app_engine_application.app]
  project    = data.google_project.project.project_id
  role       = "roles/cloudsql.client"
  member     = format("serviceAccount:%s@appspot.gserviceaccount.com", data.google_project.project.project_id)
}

resource "google_project_iam_member" "secret" {
  depends_on = [google_app_engine_application.app]
  project    = data.google_project.project.project_id
  role       = "roles/secretmanager.secretAccessor"
  member     = format("serviceAccount:%s@appspot.gserviceaccount.com", data.google_project.project.project_id)
}

resource "google_project_iam_member" "gcs" {
  depends_on = [google_app_engine_application.app]
  project    = data.google_project.project.project_id
  role       = "roles/storage.objectAdmin"
  member     = format("serviceAccount:service-%s@gae-api-prod.google.com.iam.gserviceaccount.com", data.google_project.project.number)
}

resource "google_project_iam_member" "gae_gcs" {
  depends_on = [google_app_engine_application.app]
  project    = data.google_project.project.project_id
  role       = "roles/storage.objectViewer"
  member     = format("serviceAccount:%s@appspot.gserviceaccount.com", data.google_project.project.project_id)
}

resource "google_project_iam_member" "gae_api" {
  depends_on = [google_app_engine_application.app]
  project    = data.google_project.project.project_id
  role       = "roles/compute.networkUser"
  member     = format("serviceAccount:%s@appspot.gserviceaccount.com", data.google_project.project.project_id)
}

resource "google_app_engine_flexible_app_version" "default_app" {
  count = var.create_default_service ? 1 : 0
  service = "default"
  version_id = "mlflow-default"
  runtime    = "custom"

  deployment {
    container {
      image = "gcr.io/cloudrun/hello"
    }
  }

  liveness_check {
    path = "/"
  }

  readiness_check {
    path = "/"
  }

  automatic_scaling {
    cool_down_period = "120s"
    min_total_instances = 1
    max_total_instances = 1
    cpu_utilization {
      target_utilization = 0.5
    }
  }

  delete_service_on_destroy = false
  noop_on_destroy = true

  depends_on      = [google_app_engine_application.app]
}

resource "google_app_engine_flexible_app_version" "mlflow_app" {
  service    = var.mlflow_server
  version_id = "v0"
  runtime    = "custom"

  deployment {
    container {
      image = var.docker_image_name
    }
  }

  liveness_check {
    path = "/"
  }

  readiness_check {
    path = "/"
  }

  env_variables = local.env_variables

  automatic_scaling {
    cool_down_period    = "120s"
    max_total_instances = var.max_appengine_instances
    min_total_instances = var.min_appengine_instances
    cpu_utilization {
      target_utilization = 0.5
    }
  }

  resources {
    cpu       = 1
    memory_gb = 2
  }
  network {
    name = var.network_short_name
  }

  beta_settings = {
    cloud_sql_instances = format("%s=tcp:3306", var.db_instance)
  }

  delete_service_on_destroy = true
  noop_on_destroy = false

  timeouts {
    create = "20m"
  }
  depends_on      = [
    google_app_engine_flexible_app_version.default_app,
    google_project_iam_member.gcs,
    google_project_iam_member.gae_gcs,
    google_project_iam_member.cloudsql,
    google_project_iam_member.secret,
    google_project_iam_member.gae_api
  ]
}

resource "google_iap_brand" "project_brand" {
  count = var.consent_screen_support_email == "" ? 0 : 1
  support_email     = var.consent_screen_support_email
  application_title = "mlflow"
  project           = data.google_project.project.number
}
resource "google_iap_client" "project_client" {
  count = var.consent_screen_support_email == "" ? 0 : 1
  display_name = "mlflow"
  brand        = google_iap_brand.project_brand[0].name
}

resource "google_iap_app_engine_service_iam_member" "member" {
  for_each = toset(var.web_app_users)
  project  = data.google_project.project.project_id
  app_id   = data.google_project.project.project_id
  service  = google_app_engine_flexible_app_version.mlflow_app.service
  role     = "roles/iap.httpsResourceAccessor"
  member   = each.key
}
