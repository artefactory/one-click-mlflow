output "network_self_link" {
  value = data.google_compute_network.default_network.self_link
}

output "network_short_name" {
  value = data.google_compute_network.default_network.name
}