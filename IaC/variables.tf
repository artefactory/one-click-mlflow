variable "project_id" {
    description = "GCP project"
    type = string
}
variable "artifacts_bucket" {
    description = "GCS bucket used to store your artifacts"
    type = string
    default = "oneclick-mlflow-store"
}
variable "db_password_value" {
    description = "Database password to connect to your instance"
    type = string
}
variable "mlflow_docker_image" {
    description = "Docker image used in container registry"
    type = string
}
variable "network_name" {
    description = "Network used"
    type = string
    default = "default-private"
}