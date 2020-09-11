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


resource "google_service_account" "service_account_cloud_run" {
  account_id   = format("cloud-run-%s", var.server_name)
  display_name = "Cloud run service account used"
}

resource "google_project_iam_member" "cloudsql" {
  project = google_service_account.service_account_cloud_run.project
  role    = "roles/cloudsql.client"
  member  = format("serviceAccount:%s", google_service_account.service_account_cloud_run.email)
}

resource "google_project_iam_member" "secret" {
  project = google_service_account.service_account_cloud_run.project
  role    = "roles/secretmanager.secretAccessor"
  member  = format("serviceAccount:%s", google_service_account.service_account_cloud_run.email)
}

resource "google_project_iam_member" "gcs" {
  project = google_service_account.service_account_cloud_run.project
  role    = "roles/storage.objectAdmin"
  member  = format("serviceAccount:%s", google_service_account.service_account_cloud_run.email)
}


resource "google_cloud_run_service" "default" {
  name     = var.server_name
  location = var.location

  template {
    spec {
      service_account_name = google_service_account.service_account_cloud_run.email
      containers {
        image = var.docker_image_name
        dynamic "env" {
            for_each = local.env_variables
            content {
            name = env.key
            value = env.value
            }
        }
        resources {
            limits = {
                cpu = var.cpu_limit
                memory = var.memory_limit
            }
        }
      }
    }
    metadata {
      annotations = {
        "run.googleapis.com/cloudsql-instances" = var.sql_instance_name
        "run.googleapis.com/vpc-access-connector" = var.vpc_connector
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
  autogenerate_revision_name = true
  depends_on = [google_project_iam_member.cloudsql, google_project_iam_member.secret, google_project_iam_member.gcs, var.module_depends_on]
}



data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}