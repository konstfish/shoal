
resource "kubernetes_manifest" "fleet_projects" {
  manifest = yamldecode(file("${path.module}/kubernetes/fleet-gitops.yaml"))
}
