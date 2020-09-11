output "instance_connection_name" {
  description = "Connection string used to connect to the instance"
  value       = google_sql_database_instance.this_instance.connection_name
}
output "private_ip" {
  description = "Private ip connect to the instance"
  value       = google_sql_database_instance.this_instance.private_ip_address
}
output "database_name" {
  description = "The name of the database"
  value       = google_sql_database.this_database.name
}
