# outputs.tf

output "nextcloud_db_name" {
  value = var.mysql_database
}

output "nextcloud_container_name" {
  value = var.enable_nextcloud ? docker_container.nextcloud[0].name : null
}
