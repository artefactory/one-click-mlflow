variable "network_name" {
    type = string
    description = "Name of the network to attach to. If empty, a new network will be created"
}

variable "network_name_local" {
    type = string
    description = "Name of the network to create if network_name does not exist already"
    default = "mlflow-network"
}

