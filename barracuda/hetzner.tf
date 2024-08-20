// namespace
resource "kubernetes_namespace" "hetzner" {
  metadata {
    name = "hetzner"
  }

  depends_on = [
    local_file.ansible_inventory
  ]

  lifecycle {
    ignore_changes = [
      metadata.0.labels,
      metadata.0.annotations,
    ]
  }
}

resource "kubernetes_secret" "hcloud_token" {
  metadata {
    name      = "hcloud"
    namespace = "hetzner"
  }

  data = {
    "token" = var.hcloud_token
  }

  depends_on = [
    kubernetes_namespace.hetzner
  ]
}