resource "google_compute_network" "private_network" {
  count = length(var.network_name) > 0 ? 0 : 1
  name = var.network_name_local
  auto_create_subnetworks = true
}

resource "google_compute_global_address" "private_ip_addresses" {
  name          = "private-ip-addresses"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = length(var.network_name) > 0 ? var.network_name : google_compute_network.private_network[0].name
}

resource "google_service_networking_connection" "peering_connection" {
  network                 = length(var.network_name) > 0 ? var.network_name : google_compute_network.private_network[0].name
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_addresses.name]
}

data "google_compute_network" "default_network" {
  name = length(var.network_name) > 0 ? var.network_name : google_compute_network.private_network[0].name
  depends_on = [google_service_networking_connection.peering_connection]
}