resource "google_service_account" "service_account_cloud_run" {
  account_id   = format("cloud-run-%s", server_name)
  display_name = "Cloud run service account used"
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
            for_each = var.env_variables
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
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
  autogenerate_revision_name = true
}

resource "google_project_iam_member" "cloudsql" {
  project = google_cloud_run_service.default.project
  role    = "roles/cloudsql.client"
  member  = format("serviceAccount:%s", google_service_account.service_account_cloud_run.email)
}

resource "google_project_iam_member" "secret" {
  project = google_cloud_run_service.default.project
  role    = "roles/secretmanager.secretAccessor"
  member  = format("serviceAccount:%s", google_service_account.service_account_cloud_run.email)
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