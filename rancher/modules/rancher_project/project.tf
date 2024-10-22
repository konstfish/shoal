// projects
resource "rancher2_project" "default" {
  name       = lower("${var.project_prefix}${var.project_name}")
  cluster_id = var.cluster_id
}

resource "rancher2_global_role_binding" "default" {
  for_each = var.tenant_map

  global_role_id     = "user-base"
  group_principal_id = "github_user://${each.value}"

  depends_on = [rancher2_project.default]
}

resource "rancher2_project_role_template_binding" "default" {
  for_each = var.tenant_map

  name              = lower("template-binding-${each.key}")
  project_id        = rancher2_project.default.id
  role_template_id  = "project-tenant"
  user_principal_id = "github_user://${each.value}"

  depends_on = [rancher2_project.default, rancher2_global_role_binding.default]
}