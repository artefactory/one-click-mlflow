variable "project_id" {
  description="Random string to append to project name/id to make it unique"
}

variable "folder_id" {
  description="Unique id for the folder containing the new project"
}

variable "billing_account" {
  description="Billing account id to link to the new project"
}

variable "birth_project_number" {
  description="Project number of the project deploying the IaC"
}