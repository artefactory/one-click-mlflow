variable "server_name" {
    type = string
    description = "Name of your cserver"
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
