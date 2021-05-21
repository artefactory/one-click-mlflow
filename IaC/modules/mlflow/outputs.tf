output "app_id" {
  value = module.server.app_id
}

output "mlflow_service" {
  value = module.server.mlflow_service
}

output "artifacts_bucket_name" {
  value = module.artifacts.name
}