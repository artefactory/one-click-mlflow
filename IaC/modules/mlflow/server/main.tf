locals {
  env_variables = merge(
    {
      "GCP_PROJECT"=var.project_id,
      "DB_PASSWORD_NAME"=var.db_password_name,
      "DB_USERNAME"=var.db_username,
      "DB_NAME"=var.db_name,
      "DB_PRIVATE_IP"=var.db_private_ip,
      "GCS_BACKEND"=var.gcs_backend
    }, var.env_variables)
}

data "google_project" "project" {
}

resource "google_app_engine_application" "app" {
  location_id = var.location
}

resource "google_project_iam_member" "cloudsql" {
  project = data.google_project.project.project_id
  role    = "roles/cloudsql.client"
  member = format("serviceAccount:service-%s@gae-api-prod.google.com.iam.gserviceaccount.com", data.google_project.project.number)
}

resource "google_project_iam_member" "secret" {
  project = data.google_project.project.project_id
  role    = "roles/secretmanager.secretAccessor"
  member = format("serviceAccount:service-%s@gae-api-prod.google.com.iam.gserviceaccount.com", data.google_project.project.number)
}

resource "google_project_iam_member" "gcs" {
  project = data.google_project.project.project_id
  role    = "roles/storage.objectAdmin"
  member = format("serviceAccount:service-%s@gae-api-prod.google.com.iam.gserviceaccount.com", data.google_project.project.number)
}

resource "google_project_iam_member" "gae_api" {
  project = data.google_project.project.project_id
  role    = "roles/compute.networkUser"
  member = format("serviceAccount:service-%s@gae-api-prod.google.com.iam.gserviceaccount.com", data.google_project.project.number)
}

resource "google_app_engine_flexible_app_version" "myapp_v1" {
  version_id = "v1"
  service    = var.server_name
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

  vpc_access_connector {
    name = var.vpc_connector
  }

  noop_on_destroy = true
}