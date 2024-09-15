# outputs.tf

output "nextcloud_db_name" {
  value = var.mysql_database
}

output "nextcloud_container_name" {
  value = docker_container.nextcloud.name
}
