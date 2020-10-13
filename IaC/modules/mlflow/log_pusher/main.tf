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
  role    = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.log_pusher.email}"
}