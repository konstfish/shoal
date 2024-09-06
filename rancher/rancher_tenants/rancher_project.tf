// projects
resource "rancher2_project" "user_projects" {
  for_each = local.user_map

  name       = lower(each.value.login)
  cluster_id = data.rancher2_cluster.tetra.id

  resource_quota {
    // learn dynamic blocks idk
    project_limit {
      limits_cpu = lookup(var.tenant_limits, lower(each.value.login), var.tenant_default_limit).limits_cpu
      limits_memory = lookup(var.tenant_limits, lower(each.value.login), var.tenant_default_limit).limits_memory
      requests_storage = lookup(var.tenant_limits, lower(each.value.login), var.tenant_default_limit).requests_storage
    }
    namespace_default_limit {
      limits_cpu = lookup(var.tenant_limits, lower(each.value.login), var.tenant_default_limit).limits_cpu
      limits_memory = lookup(var.tenant_limits, lower(each.value.login), var.tenant_default_limit).limits_memory
      requests_storage = lookup(var.tenant_limits, lower(each.value.login), var.tenant_default_limit).requests_storage
    }
  }
  container_resource_limit {
    limits_cpu      = "150m"
    requests_cpu    = "50m"
    limits_memory   = "150Mi"
    requests_memory = "50Mi"
  }

  labels = {
    "tenant" = each.value.login
  }
}

resource "rancher2_namespace" "user_namespaces" {
  for_each = local.user_map

  name       = lower(each.value.login)
  project_id = rancher2_project.user_projects[each.value.login].id

  labels = {
    "tenant"                      = each.value.login
    "kubernetes.io/metadata.name" = lower(each.value.login)
    "ingress"                     = "true"
    "billing"                     = "none"
  }

  lifecycle {
    ignore_changes = [
      container_resource_limit
    ]
  }
}

resource "rancher2_global_role_binding" "rancher_user" {
  for_each = local.user_map

  name = lower(each.value.login)
  global_role_id = "user-base"
  group_principal_id = "github_user://${data.github_user.org_users[each.value.login].id}"
}

resource "rancher2_project_role_template_binding" "user_projects_binding" {
  for_each = local.user_map

  name              = lower("template-binding-${each.value.login}")
  project_id        = lower(rancher2_project.user_projects[each.value.login].id)
  role_template_id  = "project-tenant"
  user_principal_id = "github_user://${data.github_user.org_users[each.value.login].id}"

  depends_on = [ rancher2_global_role_binding.rancher_user, rancher2_project.user_projects ] # , kubernetes_manifest.project_tenant_role ]
}