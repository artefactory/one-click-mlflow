variable "server_name" {
    type = string
    description = "Name of your server"
}
variable "location" {
    type = string
    description = "Location to deploy your server"
    default = "europe-west"
}
variable "docker_image_name" {
    type = string
    description = "Name of the docker image"
}
variable "env_variables" {
    type = map
    description = "Env variable to be used in your container"
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
variable "db_instance" {
    description = "Name of the database instance"
    type = string
}
variable "gcs_backend" {
    description = "Gcs bucket used for artifacts"
    type = string
}
variable "db_private_ip" {
    type = string
    description = "Private ip of the db"
}
variable "module_depends_on" {
    type    = any
    default = null
}
variable "consent_screen_support_email" {
    type = string
    description = "Person or group to contact in case of problem"
}
variable "web_app_users" {
    type = list(string)
    description = "List of people who can acess the mlflow web app. e.g. [user:jane@example.com, group:people@example.com]"
}
variable "service" {
    default = "default"
}
variable "network_short_name" {}
variable "max_appengine_instances" {
    default = 1
}
variable "min_appengine_instances" {
    default = 1
}
