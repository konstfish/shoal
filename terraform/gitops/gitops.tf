
resource "kubernetes_manifest" "fleet_projects_local" {
  manifest = yamldecode(file("${path.module}/kubernetes/fleet-local.yaml"))
}

resource "kubernetes_manifest" "fleet_projects_default" {
  manifest = yamldecode(file("${path.module}/kubernetes/fleet-default.yaml"))
}
