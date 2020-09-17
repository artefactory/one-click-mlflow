resource "google_secret_manager_secret" "secret" {
  provider = google-beta

  secret_id = var.secret_id

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "secret-version" {
  provider = google-beta

  secret = google_secret_manager_secret.secret.id

  secret_data = var.secret_value
  depends_on = [google_secret_manager_secret.secret]
}
