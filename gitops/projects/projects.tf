resource "kubernetes_manifest" "project_angler" {
  manifest = yamldecode(file("${path.module}/angler.yaml"))
}

resource "kubernetes_manifest" "project_vaultwarden" {
  manifest = yamldecode(file("${path.module}/vaultwarden.yaml"))
}

resource "kubernetes_manifest" "project_storagekf" {
  manifest = yamldecode(file("${path.module}/sdot.yaml"))
}

resource "kubernetes_manifest" "project_streaks_api" {
  manifest = yamldecode(file("${path.module}/streaks-api.yaml"))
}
resource "kubernetes_manifest" "project_pocketbase_sudoku" {
  manifest = yamldecode(file("${path.module}/pocketbase-sudoku.yaml"))
}