output "secret_value" {
  description = "Value of the created secret"
  value       = google_secret_manager_secret_version.secret-version.secret_data
}
