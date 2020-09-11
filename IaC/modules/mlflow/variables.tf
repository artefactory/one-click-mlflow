variable "artifacts_bucket_name" {
    description = "Name of the mlflow bucket created to store artifacts"
    type = string
}
variable "artifacts_bucket_location" {
    description = "Location of the mlflow artifact bucket deployed"
    type = string
    default = "EUROPE-WEST1"
}
variable "artifacts_number_of_version" {
    description = "Number of file version kept in your artifacts bucket"
    type = number
    default = 1
}
variable "artifacts_storage_class" {
    description = "Storage class of your artifact bucket"
    type = string
    default = "STANDARD"
}
variable "db_password_name" {
    description = "Name of the database password stored in secret manager"
    type = string
    default = "mlflow-db-pwd"
}
variable "db_password_value" {
    description = "Value of the database password stored in secret manager"
    type = string
}
variable "db_username" {
    description = "Value of the database username"
    type = string
    default = "mlflowuser"
}
variable "db_instance_prefix" {
    description = "prefix used as database instance name"
    type = string
    default = "mlflow"
}
variable "db_version" {
    description = "Database instance version in GCP"
    type = string
    default = "MYSQL_5_7"
}
variable "db_region" {
    description = "Database region"
    type = string
    default = "europe-west1"
}
variable "private_vpc_connection" {
    description = "Vpc connection with the database"
    type = any
}
variable "db_size" {
    description = "Database instance size"
    type = string
    default = "db-f1-micro"
}
variable "network_link" {
    description = "Link to your network"
    type = string
}
variable "db_availability_type" {
    description = "Availability of your database"
    type = string
    default = "ZONAL"
}
variable "db_name" {
    description = "Name of the database created inside the instance"
    type = string
    default = "mlflow"
}
variable "mlflow_server" {
    description = "Name of the mlflow server deployed to cloud run"
    type = string
    default = "mlflow"
}
variable "server_location" {
    description = "Location to deploy cloud run server"
    type = string
    default = "europe-west1"
}
variable "server_docker_image" {
    description = "Docker image name of your mlflow server"
    type = string
}
variable "server_env_variables" {
    description = "Env variables used inside your container"
    type = map
    default = {}
}
variable "project_id" {
    description = "GCP project"
    type = string
}
variable "vpc_connector" {
    type = string
    description = "Vpc connector of your private network"
}
variable "module_depends_on" {
  type    = any
  default = null
}
