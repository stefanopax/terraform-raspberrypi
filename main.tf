terraform {  
  required_providers {  
    docker = {  
      source  = "kreuzwerker/docker"  
      version = "~> 3.0.2"  # specify a version if necessary  
    }  
  }  
}  

provider "docker" {}  

resource "docker_network" "nextcloud_network" {  
  name = "nextcloud_network"  
}  

resource "docker_container" "plex" {  
  name    = "plex"  # Added name argument  
  image   = "linuxserver/plex:1.40.5"  
  restart = "unless-stopped"  
  env = [  
    "TZ=Europe/Zurich",  
    "VERSION=docker",  
    "PUID=1002",  
    "GUID=1002"  
  ]  
  network_mode = "host"  
  
  volumes {  
    host_path      = "/media/stefanopax/Storage/App/PlexData/Config"  
    container_path = "/config"  
  }  
  volumes {  
    host_path      = "/media/stefanopax/Storage/App/PlexData/Transcode"  
    container_path = "/transcode"  
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

resource "docker_container" "qbittorrent" {  
  name    = "qbittorrent"  # Added name argument  
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

resource "docker_container" "nextcloud" {  
  name    = "nextcloud"  # Added name argument  
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
    host_path      = "/media/stefanopax/Storage/App/NextcloudData"  
    container_path = "/data"  
  }  
  volumes {  
    host_path      = "/media/stefanopax/Storage/App/NextcloudConfig"  
    container_path = "/config"  
  }  
  volumes {  
    host_path      = "/media/stefanopax/Storage/App/Nextcloud"  
    container_path = "/var/www/html"  
  }  
  network_mode = docker_network.nextcloud_network.name  # Use network_mode instead  
}  

resource "docker_container" "nextclouddb" {  
  name    = "nextclouddb"  # Added name argument  
  image   = "mariadb:11.5.2"  
  restart = "unless-stopped"  
  env = [  
    "PUID=999",  
    "PGID=990",  
    "MYSQL_ROOT_PASSWORD=root",  
    "MYSQL_DATABASE=nextcloud",  
    "MYSQL_USER=nextcloud",  
    "MYSQL_PASSWORD=mysql"  
  ]  
  
  volumes {  
    host_path      = "/media/stefanopax/Storage/App/NextcloudDB"  
    container_path = "/var/lib/mysql"  
  }  
  network_mode = docker_network.nextcloud_network.name  # Use network_mode instead  
}
