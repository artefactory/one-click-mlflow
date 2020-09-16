variable "server_name" {
    type = string
    description = "Name of your server"
}
variable "location" {
    type = string
    description = "Location to deploy your server"
    default = "europe-west1"
}
variable "docker_image_name" {
    type = string
    description = "Name of the docker image"
}
variable "env_variables" {
    type = map
    description = "Env variable to be used in your container"
}
variable "sql_instance_name" {
    type = string
    description = "Sql instance name your server needs access to"
}
variable "project_id" {
    description = "GCP project"
    type = string
}
variable "db_password_name" {
    description = "Name of the db password stored in secret manager"
    type = string
}
variable "db_username" {
    description = "Username used to connect to your db"
    type = string
}
variable "db_name" {
    description = "Name of the database"
    type = string
}
variable "gcs_backend" {
    description = "Gcs bucket used for artifacts"
    type = string
}
variable "cpu_limit" {
    type = string
    description = "Maximum cpu"
    default = "1000m"
}
variable "memory_limit" {
    type = string
    description = "Memory limit of your container"
    default = "1024Mi"
}
variable "vpc_connector" {
    type = string
    description = "Vpc connector of your private network"
}
variable "db_private_ip" {
    type = string
    description = "Private ip of the db"
}
variable "module_depends_on" {
  type    = any
  default = null
}
variable "service_account_mlflow_users" {
    type = string
    default = "mlflow-users"
    description = "Service account created to connect to mlflow"
}