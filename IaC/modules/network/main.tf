# GNU Lesser General Public License v3.0 only
# Copyright (C) 2020 Artefact
# licence-information@artefact.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
resource "google_compute_network" "private_network" {
  count                   = length(var.network_name) > 0 ? 0 : 1
  name                    = var.network_name_local
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "allow-internal" {
  count   = length(var.network_name) > 0 ? 0 : 1
  name    = "${var.network_name_local}-allow-internal"
  network = google_compute_network.private_network[0].name

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  # Default internal range where our private network subnetworks are deployed.
  # c.f. https://www.terraform.io/docs/providers/google/r/compute_network.html#auto_create_subnetworks
  source_ranges = ["10.128.0.0/9"]
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
  name       = length(var.network_name) > 0 ? var.network_name : google_compute_network.private_network[0].name
  depends_on = [google_service_networking_connection.peering_connection]
}