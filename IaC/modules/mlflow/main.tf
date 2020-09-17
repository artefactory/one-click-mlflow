module "artifacts" {
    source = "./artifacts"
    bucket_name = var.artifacts_bucket_name
    bucket_location = var.artifacts_bucket_location
    number_of_version = var.artifacts_number_of_version
    storage_class = var.artifacts_storage_class
}

module "db_secret" {
    source = "./secret_manager"
    secret_id = var.db_password_name
    secret_value = var.db_password_value
}

module "database" {
    source = "./database"
    instance_prefix = var.db_instance_prefix
    database_version = var.db_version
    region = var.db_region
    private_vpc_connection = var.private_vpc_connection
    size = var.db_size
    network_link = var.network_link
    availability_type = var.db_availability_type
    database_name = var.db_name
    username = var.db_username
    password = module.db_secret.secret_value
}

module "server" {
    source = "./server"
    server_name = var.mlflow_server
    location = var.server_location
    docker_image_name = var.server_docker_image
    env_variables = var.server_env_variables
    sql_instance_name = module.database.instance_connection_name
    db_private_ip = module.database.private_ip
    project_id = var.project_id
    db_password_name = var.db_password_name
    db_username = var.db_username
    db_name = var.db_name
    gcs_backend = module.artifacts.url
    vpc_connector = var.vpc_connector
    module_depends_on = var.module_depends_on
}
