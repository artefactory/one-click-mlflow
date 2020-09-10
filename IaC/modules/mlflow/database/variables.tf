variable "instance_prefix" {
    type = string
    description = "Name of the database instance you want to deploy"
    default = "mlflow"
}
variable "database_version" {
    type = string
    description = "Version of the database instance you use"
    default = "MYSQL_5_6"
}
variable "region" {
    type = string
    description = "Region of the database instance"
    default = "europe-west1"
}
variable "private_vpc_connection" {
    type = string
    description = "Private connection used to connect your instance with"
}
variable "size" {
    type = string
    description = "Size of the database instance"
    default = "db-f1-micro"
}
variable "network_link" {
    type = string
    description = "Network link you want to connect your database with" 
}
variable "availability_type" {
    type = string
    description = "Availability of your instance" 
    default = "ZONAL"
}
variable "database_name" {
    type = string
    description = "Name of the database created"
    default = "mlflow"
}
variable "username" {
    type = string
    description = "Username to connect to database instance"
}
variable "password" {
    type = string
    description = "Password to connect to database instance" 
}
