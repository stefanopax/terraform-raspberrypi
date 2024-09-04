# Terraform Docker Setup

This repo contains Terraform configuration for Docker containers on a Raspberry Pi, managing Plex, qBittorrent, Nextcloud, and MariaDB.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [Docker](https://docs.docker.com/engine/install/)

## Usage

1. Clone the repo:
    ```bash
    git clone https://github.com/your-repo/terraform-docker
    cd terraform-docker
    ```

2. Initialize and apply the Terraform configuration:
    ```bash
    terraform init
    terraform apply
    ```

3. Confirm the changes with `yes`.

## Configuration Overview

- **Docker Network**: Creates `nextcloud_network` for Nextcloud and MariaDB.

- **Plex**: Configured with host paths for config, transcode, and media storage.
    ```hcl
    resource "docker_container" "plex" { image = "linuxserver/plex:1.40.5" ... }
    ```

- **qBittorrent**: Configured with host paths for downloads and config.
    ```hcl
    resource "docker_container" "qbittorrent" { image = "linuxserver/qbittorrent:4.6.6" ... }
    ```

- **Nextcloud & MariaDB**: Linked via `nextcloud_network`.
    ```hcl
    resource "docker_container" "nextcloud" { image = "linuxserver/nextcloud:29.0.5" ... }
    resource "docker_container" "nextclouddb" { image = "mariadb:11.5.2" ... }
    ```

## Cleanup

Remove all containers and resources:
```bash
terraform destroy
```