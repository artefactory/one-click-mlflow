resource "google_cloud_run_service" "default" {
  name     = var.server_name
  location = var.location

  template {
    spec {
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