resource "google_project" "temp_project" {
  name       = var.project_id
  project_id = var.project_id
  folder_id  = var.folder_id
  billing_account = var.billing_account
  labels = merge(jsondecode(var.project_labels), {"expiry_date"=replace(lower(tostring(timeadd(timestamp(),"24h"))),":","-")})
}

resource "google_project_iam_binding" "project_owners" {
  project = google_project.temp_project.project_id
  role    = "roles/owner"
  members = [
    "serviceAccount:${var.birth_project_number}@cloudbuild.gserviceaccount.com",
    "user:${var.project_owner}"
  ]

  depends_on = [google_project.temp_project]
}