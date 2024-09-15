# variables.tf

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
