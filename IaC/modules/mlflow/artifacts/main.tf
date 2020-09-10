resource "google_storage_bucket" "this" {
  name          = var.bucket_name
  location      = var.bucket_location
  storage_class = var.storage_class
  versioning {
    enabled = var.versioning_enabled
  }
  lifecycle_rule {
    condition {
      num_newer_versions = var.number_of_version
    }
    action {
      type = "Delete"
    }
  }
}