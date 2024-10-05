resource "helm_release" "longhorn" {
  name             = "longhorn"
  repository       = "https://charts.longhorn.io"
  chart            = "longhorn"
  namespace        = "longhorn-system"
  create_namespace = true

  set {
    name  = "defaultSettings.backupTarget"
    value = var.longhorn_s3_bucket
  }

  set {
    name  = "defaultSettings.backupTargetCredentialSecret"
    value = "longhorn-backup-secret"
    // value = kubernetes_secret.longhorn_backup_secret.metadata[0].name
  }
}

resource "kubernetes_secret" "longhorn_backup_secret" {
  metadata {
    name      = "longhorn-backup-secret"
    namespace = helm_release.longhorn.namespace
  }

  data = {
    AWS_ACCESS_KEY_ID     = var.longhorn_s3_access_key
    AWS_SECRET_ACCESS_KEY = var.longhorn_s3_secret_key
    AWS_ENDPOINTS         = var.longhorn_s3_endpoint
  }

  type = "Opaque"
}
