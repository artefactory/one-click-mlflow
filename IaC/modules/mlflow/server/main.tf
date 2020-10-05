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
  iap {
    enabled = true
    oauth2_client_id = google_iap_client.project_client.client_id
    oauth2_client_secret = google_iap_client.project_client.secret
  }
}

resource "google_project_iam_member" "cloudsql" {
  project = data.google_project.project.project_id
  role    = "roles/cloudsql.client"
  member = format("serviceAccount:%s@appspot.gserviceaccount.com", data.google_project.project.name)
}

resource "google_project_iam_member" "secret" {
  project = data.google_project.project.project_id
  role    = "roles/secretmanager.secretAccessor"
  member = format("serviceAccount:%s@appspot.gserviceaccount.com", data.google_project.project.name)
}

resource "google_project_iam_member" "gcs" {
  project = data.google_project.project.project_id
  role    = "roles/storage.objectAdmin"
  member = format("serviceAccount:service-%s@gae-api-prod.google.com.iam.gserviceaccount.com", data.google_project.project.number)
}

resource "google_project_iam_member" "gae_api" {
  project = data.google_project.project.project_id
  role    = "roles/compute.networkUser"
  member  = format("serviceAccount:%s@appspot.gserviceaccount.com", data.google_project.project.name)
}

resource "google_app_engine_flexible_app_version" "myapp_v1" {
  service    = var.service
  version_id = "v1"
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
    cool_down_period = "120s"
    max_total_instances =  1
    min_total_instances = 1
    cpu_utilization {
      target_utilization = 0.5
    }
  }
  resources {
    cpu = 1
    memory_gb = 2
  }
  network {
      name = var.network_short_name
  }

  beta_settings = {
      cloud_sql_instances = format("%s=tcp:3306", var.db_instance)
  }

  noop_on_destroy = true
  depends_on = [google_project_iam_member.gcs, google_project_iam_member.cloudsql, google_project_iam_member.secret, google_project_iam_member.gae_api]
}

resource "google_iap_brand" "project_brand" {
  support_email     = var.consent_screen_support_email
  application_title = "mlflow"
  project           = data.google_project.project.number
}
resource "google_iap_client" "project_client" {
  display_name = "mlflow"
  brand        =  google_iap_brand.project_brand.name
}
resource "google_iap_app_engine_service_iam_binding" "member" {
  project = data.google_project.project.name
  app_id = data.google_project.project.name
  service = google_app_engine_flexible_app_version.myapp_v1.service
  role = "roles/iap.httpsResourceAccessor"
  members = var.web_app_users
  depends_on = [google_app_engine_flexible_app_version.myapp_v1]
}

resource "google_service_account" "log_pusher" {
  account_id   = "mlflow-log-pusher"
  display_name = "mlflow log pusher"
}

resource "google_project_iam_member" "log_pusher_iap" {
  depends_on = [google_iap_app_engine_service_iam_binding.member]
  project = data.google_project.project.project_id
  role    = "roles/iap.httpsResourceAccessor"
  member = "serviceAccount:${google_service_account.log_pusher.email}"
}

resource "google_project_iam_member" "log_pusher_storage" {
  project = data.google_project.project.project_id
  role    = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.log_pusher.email}"
}