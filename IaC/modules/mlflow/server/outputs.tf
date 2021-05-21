output "app_id" {
  value = google_app_engine_application.app.app_id
}

output "mlflow_service" {
  value = google_app_engine_flexible_app_version.mlflow_app.service
}