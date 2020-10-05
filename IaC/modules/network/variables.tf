variable "vpc_name" {
    type        = string
    description = "Name of the network you want to create"
}
variable "region" {
    type = string
    description = "Region to deploy your vpc connector"
    default = "europe-west1"
}
variable "vpc_connector_regions" {
    type        = map
    description = "Regions where the VPC Access connector resides and the matching ip cidr range"
    default = {
        "europe-west1" = "10.8.0.0/28"
    }
}