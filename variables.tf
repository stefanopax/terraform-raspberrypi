# variables.tf

# Versions
variable "plex_version" {
  description = "Linuxserver Plex image version"
  type        = string
  default     = "1.43.2"
}

variable "qbittorrent_version" {
  description = "Linuxserver Qbittorrent image version"
  type        = string
  default     = "5.2.1"
}

variable "nextcloud_version" {
  description = "Linuxserver Nextcloud image version"
  type        = string
  default     = "34.0.0"
}

variable "mariadb_version" {
  description = "MariaDB image version for Nextcloud DB"
  type        = string
  default     = "12.3.2"
}

# MySQL variables
variable "mysql_database" {
  description = "The MySQL database name"
  type        = string
}

variable "mysql_password" {
  description = "The MySQL user password"
  type        = string
}

variable "mysql_root_password" {
  description = "The MySQL root password"
  type        = string
}

variable "mysql_user" {
  description = "The MySQL user"
  type        = string
}

# K3s
variable "enable_k3s" {
  description = "Toggle to enable or disable the K3s cluster"
  type        = bool
  default     = false
}

# Nextcloud
variable "enable_nextcloud" {
  description = "Toggle to enable or disable Nextcloud and its database"
  type        = bool
  default     = false
}
