resource "google_project_service" "project" {
  count = length(var.services)
  project = var.project_id
  service = var.services[count.index]
  disable_dependent_services = true
}
