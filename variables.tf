# variables.tf

# Versions
variable "plex_version" {
  description = "Linuxserver Plex image version"
  type        = string
  default     = "1.41.8"
}

variable "qbittorrent_version" {
  description = "Linuxserver Qbittorrent image version"
  type        = string
  default     = "5.0.4"
}

variable "nextcloud_version" {
  description = "Linuxserver Nextcloud image version"
  type        = string
  default     = "31.0.0"
}

variable "mariadb_version" {
  description = "MariaDB image version for Nextcloud DB"
  type        = string
  default     = "11.7.2"
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
