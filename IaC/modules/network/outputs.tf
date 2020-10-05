output "network_link" {
  description = "Link of the created network"
  value       = google_compute_network.vpc.self_link
}
output "private_vpc_connection" {
  description = "Private vpc connection to servicenetworking"
  value = google_service_networking_connection.private_vpc_connection
}
output "vpc_connector" {
  description = "Connector to your private network"
  value = google_vpc_access_connector.vpc_con.self_link
}
