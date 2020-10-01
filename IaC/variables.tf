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
variable "consent_screen_support_email" {
    type = string
    description = "Person or group to contact in case of problem (address shown in the OAuth consent screen)"
}
variable "web_app_users" {
    type = list(string)
    description = "List of people who can acess the mlflow web app. e.g. [user:jane@example.com, group:people@example.com]"
}