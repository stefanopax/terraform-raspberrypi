resource "null_resource" "start_k3s" {
  count = var.enable_k3s ? 1 : 0

  provisioner "local-exec" {
    command = "sudo systemctl start k3s"
  }
}

resource "null_resource" "deploy_k3s_manifests" {
  count = var.enable_k3s ? 1 : 0

  depends_on = [null_resource.start_k3s]

  provisioner "local-exec" {
    command = "kubectl apply -f /home/stefanopax/terraform/k3s-manifests/"
  }
}

resource "null_resource" "stop_k3s" {
  count = var.enable_k3s ? 0 : 1

  provisioner "local-exec" {
    command = "sudo systemctl stop k3s"
  }
}

