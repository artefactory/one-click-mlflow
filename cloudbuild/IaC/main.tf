resource "google_project" "temp_project" {
  name       = var.project_id
  project_id = var.project_id
  folder_id  = var.folder_id
  billing_account = var.billing_account
  labels = merge(jsondecode(var.project_labels), {"expiry_date"=replace(lower(tostring(timeadd(timestamp(),"24h"))),":","-")})
}

resource "google_service_account" "mlflow_creator" {
  project      = google_project.temp_project.project_id
  account_id   = "mlflow-creator"
  display_name = "mlflow creator"

  depends_on = [google_project.temp_project]
}

resource "google_project_iam_binding" "project_owners" {
  project = google_project.temp_project.project_id
  role    = "roles/owner"
  members = [
    "serviceAccount:${var.birth_project_number}@cloudbuild.gserviceaccount.com",
    "user:${var.project_owner}",
    "serviceAccount:${google_service_account.mlflow_creator.email}"
  ]

  depends_on = [google_service_account.mlflow_creator]
}

resource "google_project_iam_member" "mlflow_creator_bucket_access" {
  project = var.project_id
  member  = "serviceAccount:${google_service_account.mlflow_creator.email}"
  role    = "roles/storage.objectViewer"

  depends_on = [google_service_account.mlflow_creator]
}

resource "google_project_iam_member" "mlflow_creator_service_usage_consumer" {
  project = var.project_id
  member  = "serviceAccount:${google_service_account.mlflow_creator.email}"
  role    = "roles/serviceusage.serviceUsageConsumer"

  depends_on = [google_service_account.mlflow_creator]
}

resource "google_service_account_key" "mlflow_creator_key" {
  service_account_id = google_service_account.mlflow_creator.name

  depends_on = [google_project_iam_binding.project_owners]
}

resource "local_file" "local_sa_key" {
  filename = "../../key.json"
  content  = base64decode(google_service_account_key.mlflow_creator_key.private_key)

  depends_on = [google_service_account_key.mlflow_creator_key]
}