// projects
resource "rancher2_project" "user_projects" {
  for_each = local.user_map

  name       = lower(each.value.login)
  cluster_id = data.rancher2_cluster.tetra.id

  resource_quota {
    project_limit {
      limits_cpu       = "2000m"
      limits_memory    = "2000Mi"
      requests_storage = "30Gi"
    }
    namespace_default_limit {
      limits_cpu       = "2000m"
      limits_memory    = "2000Mi"
      requests_storage = "30Gi"
    }
  }
  container_resource_limit {
    limits_cpu      = "250m"
    limits_memory   = "100Mi"
    requests_cpu    = "50m"
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

resource "rancher2_project_role_template_binding" "user_projects_binding" {
  for_each = local.user_map

  name              = lower("template-binding-${each.value.login}")
  project_id        = lower(rancher2_project.user_projects[each.value.login].id)
  role_template_id  = "project-member"
  user_principal_id = "github_user://${data.github_user.org_users[each.value.login].id}"
}