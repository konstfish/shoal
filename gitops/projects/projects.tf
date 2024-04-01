resource "kubernetes_manifest" "project_angler" {
  manifest = yamldecode(file("${path.module}/angler.yaml"))
}

resource "kubernetes_manifest" "project_vaultwarden" {
  manifest = yamldecode(file("${path.module}/vaultwarden.yaml"))
}

resource "kubernetes_manifest" "project_storagekf" {
  manifest = yamldecode(file("${path.module}/storagekf.yaml"))
}

resource "kubernetes_manifest" "project_streaks_api" {
  manifest = yamldecode(file("${path.module}/streaks-api.yaml"))
}