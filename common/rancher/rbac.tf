resource "kubernetes_manifest" "project_tenant_role" {
  manifest = yamldecode(file("${path.module}/kubernetes/project-tenant.yml"))
}