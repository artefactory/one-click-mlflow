output "network_link" {
  description = "Link of the created network"
  value       = google_compute_network.vpc.self_link
}
output "private_vpc_connection" {
  description = "Private vpc connection to servicenetworking"
  value = google_service_networking_connection.private_vpc_connection
}