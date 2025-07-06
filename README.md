# Terraform Docker + K3s Setup

This repo contains Terraform configuration to manage Docker containers and an optional K3s Kubernetes cluster on a Raspberry Pi 5. Supports Plex, qBittorrent, Nextcloud, MariaDB, and cluster workloads.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html)
- [Docker](https://docs.docker.com/engine/install/)
- [K3s](https://k3s.io/) installed and managed via `systemd`
- `kubectl` configured on the Raspberry Pi (required for manifest deployment)

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

- **Docker Containers**:
    - **Plex**: Media server with host paths for config and libraries.
    - **qBittorrent**: Torrent client with persistent config and downloads.
    - **Nextcloud & MariaDB**: Self-hosted cloud storage with a dedicated Docker network.

- **K3s Kubernetes Cluster**:
    - Controlled via Terraform with the `enable_k3s` toggle.
    - Deploys manifests from `/home/stefanopax/k3s-manifests/` if enabled.
    - Start/Stop handled via `systemctl` on the Raspberry Pi.

## K3s Toggle Example

Enable or disable the K3s cluster at apply time using:

```bash
terraform apply -var="enable_k3s=true"
```
