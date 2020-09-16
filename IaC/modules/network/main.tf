resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = true
}

resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta

  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_vpc_access_connector" "vpc_con" {
  name          = "vpc-con"
  region        = var.region
  ip_cidr_range = lookup(var.vpc_connector_regions, var.region)
  network       = google_compute_network.vpc.name
}
