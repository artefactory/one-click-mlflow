variable "vpc_name" {
    type        = string
    description = "Name of the network you want to create"
}
variable "region" {
    type = string
    description = "Region to deploy your vpc connector"
    default = "europe-west1"
}