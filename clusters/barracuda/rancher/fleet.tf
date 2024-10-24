resource "kubernetes_manifest" "fleet_projects" {
  manifest = yamldecode(file("${path.module}/kubernetes/fleet-local.yaml"))

  depends_on = [helm_release.rancher]
}