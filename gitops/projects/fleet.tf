resource "kubernetes_manifest" "project_angler" {
  manifest = yamldecode(file("${path.module}/fleet/angler.yaml"))
}

resource "kubernetes_manifest" "project_vaultwarden" {
  manifest = yamldecode(file("${path.module}/fleet/vaultwarden.yaml"))
}

resource "kubernetes_manifest" "project_storagekf" {
  manifest = yamldecode(file("${path.module}/fleet/sdot.yaml"))
}

resource "kubernetes_manifest" "project_streaks_api" {
  manifest = yamldecode(file("${path.module}/fleet/streaks-api.yaml"))
}

resource "kubernetes_manifest" "project_pocketbase_sudoku" {
  manifest = yamldecode(file("${path.module}/fleet/pocketbase-sudoku.yaml"))
}