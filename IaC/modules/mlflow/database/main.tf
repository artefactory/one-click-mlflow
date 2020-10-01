resource "random_id" "db_name_suffix" {
  byte_length = 5
}

resource "google_sql_database_instance" "this_instance" {
  name             = "${var.instance_prefix}-${random_id.db_name_suffix.hex}"
  database_version = var.database_version
  region           = var.region

  settings {
    tier = var.size
    ip_configuration {
      ipv4_enabled    = false
      private_network = "https://www.googleapis.com/compute/v1/projects/one-click-mlflow/global/networks/default"
    }
    backup_configuration {
      enabled = true
    }
    availability_type = var.availability_type

  }
}

resource "google_sql_database" "this_database" {
  name     = var.database_name
  instance = google_sql_database_instance.this_instance.name
  depends_on = [google_sql_database_instance.this_instance]
}

resource "google_sql_user" "this_user" {
  name     = var.username
  instance = google_sql_database_instance.this_instance.name
  password = var.password
  depends_on = [google_sql_database_instance.this_instance]
}
