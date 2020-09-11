variable "bucket_name" {
    description = "Name of the bucket."
    type        = string
}
variable "bucket_location" {
    description = "Location of the bucket."
    type        = string
    default     = "EUROPE-WEST1"
}
variable "versioning_enabled" {
    description = "True if you want to version your bucket."
    type        = bool
    default     = true
}
variable "number_of_version" {
    description = "Number of version you want to keep with the versionning."
    type        = number
    default     = 1
}
variable "storage_class" {
    description = "Storage class of your bucket"
    type        = string
    default     ="STANDARD"
}
variable "module_depends_on" {
  type    = any
  default = null
}