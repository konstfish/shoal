resource "helm_release" "nfs_subdir_external_provisioner" {
  name             = "nfs-subdir-external-provisioner"
  repository       = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/"
  chart            = "nfs-subdir-external-provisioner"
  namespace        = "nfs-provisioner"
  create_namespace = true

  set {
    name  = "nfs.server"
    value = var.nfs_server
  }
  set {
    name  = "nfs.path"
    value = var.nfs_path
  }
  set {
    name  = "nfs.nfs.mountOptions"
    value = var.nfs_mount_options
  }

  timeout = 100
}
