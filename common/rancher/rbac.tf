/*resource "kubernetes_manifest" "tenant_role" {
  manifest = yamldecode(file("${path.module}/kubernetes/role-tenant.yaml"))
}*/

resource "kubernetes_manifest" "project_tenant_role" {
  manifest = yamldecode(file("${path.module}/kubernetes/project-tenant.yaml"))
}