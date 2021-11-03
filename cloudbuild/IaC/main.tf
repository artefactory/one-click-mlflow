resource "google_project" "temp_project" {
  name       = var.project_id
  project_id = var.project_id
  folder_id  = var.folder_id
  billing_account = var.billing_account
  labels = merge(jsondecode(var.project_labels), {"expiry_date"=replace(lower(tostring(timeadd(timestamp(),"24h"))),":","-")})
}

resource "google_project_iam_member" "cloudbuild_ops_sa_owner" {
  project = var.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${var.birth_project_number}@cloudbuild.gserviceaccount.com"

  depends_on = [google_project.temp_project]
}

resource "google_project_iam_member" "user_owner" {
  project = var.project_id
  role    = "roles/owner"
  member  = "user:${var.project_owner}"

  depends_on = [google_project.temp_project]
}

