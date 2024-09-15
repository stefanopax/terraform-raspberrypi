terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

# Docker network for Nextcloud
resource "docker_network" "nextcloud_network" {
  name = "nextcloud_network"
}

# Plex container
resource "docker_container" "plex" {
  name    = "plex"
  image   = "linuxserver/plex:1.41.0"
  restart = "unless-stopped"
  env = [
    "TZ=Europe/Zurich",
    "VERSION=docker",
    "PUID=1002",
    "GUID=1002"
  ]
  network_mode = "host"

  volumes {
    host_path      = "/media/stefanopax/Storage/App/Plex/Config"
    container_path = "/config"
  }
  volumes {
    host_path      = "/media/stefanopax/Storage/Movies"
    container_path = "/data/movies"
  }
  volumes {
    host_path      = "/media/stefanopax/Storage/TV"
    container_path = "/data/tv"
  }
}

# qBittorrent container
resource "docker_container" "qbittorrent" {
  name    = "qbittorrent"
  image   = "linuxserver/qbittorrent:4.6.6"
  restart = "unless-stopped"
  env = [
    "PUID=1003",
    "PGID=1003",
    "TZ=Europe/Zurich"
  ]
  network_mode = "host"

  volumes {
    host_path      = "/media/stefanopax/Storage/Torrent"
    container_path = "/downloads"
  }
  volumes {
    host_path      = "/media/stefanopax/Storage/App/qbittorrent/config"
    container_path = "/config"
  }
}

# Nextcloud container
resource "docker_container" "nextcloud" {
  name    = "nextcloud"
  image   = "linuxserver/nextcloud:29.0.5"
  restart = "unless-stopped"
  env = [
    "PUID=999",
    "PGID=990",
    "TZ=Europe/Zurich"
  ]
  ports {
    internal = 80
    external = 9090
  }
  depends_on = [docker_container.nextclouddb]

  volumes {
    host_path      = "/media/stefanopax/Storage/App/Nextcloud/NextcloudData"
    container_path = "/data"
  }
  volumes {
    host_path      = "/media/stefanopax/Storage/App/Nextcloud/NextcloudConfig"
    container_path = "/config"
  }
  volumes {
    host_path      = "/media/stefanopax/Storage/App/Nextcloud"
    container_path = "/var/www/html"
  }
  network_mode = docker_network.nextcloud_network.name
}

# Nextcloud Database container
resource "docker_container" "nextclouddb" {
  name    = "nextclouddb"
  image   = "mariadb:11.5.2"
  restart = "unless-stopped"
  env = [
    "PUID=999",
    "PGID=990",
    "MYSQL_ROOT_PASSWORD=${var.mysql_root_password}",
    "MYSQL_DATABASE=${var.mysql_database}",
    "MYSQL_USER=${var.mysql_user}",
    "MYSQL_PASSWORD=${var.mysql_password}"
  ]

  volumes {
    host_path      = "/media/stefanopax/Storage/App/NextcloudDB"
    container_path = "/var/lib/mysql"
  }
  network_mode = docker_network.nextcloud_network.name
}
