variable "project_id" {
    description = "Id of your project"
    type = string
}
variable "services" {
    description = "List of url of the service you want to activate"
    type = list(string)
}