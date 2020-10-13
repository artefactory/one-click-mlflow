variable "project_id" {
    description = "GCP project"
    type = string
}
variable "backend_bucket" {
    description = "Name of the bucket."
    type        = string
}
variable "backend_bucket_location" {
    description = "Location of the bucket."
    type        = string
    default     = "EUROPE-WEST1"
}
variable "versioning_enabled" {
    description = "True if you want to version your bucket."
    type        = bool
    default     = true
}
variable "backend_bucket_number_of_version" {
    description = "Number of version you want to keep with the versionning."
    type        = number
    default     = 3
}
variable "backend_bucket_storage_class" {
    description = "Storage class of your bucket"
    type        = string
    default     ="STANDARD"
}
variable "storage_uniform" {
    type = bool
    description = "Wether or not uniform level acces is to be activated for the buckets"
    default = true
}
variable "tfstate_versionning" {
    type = bool
    description = "Wether or not the remote TFstate should be versioned"
    default = true
}