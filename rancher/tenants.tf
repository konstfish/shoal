locals {
  project_user_map = {
    for login, user in data.github_user.org_users :
    user.username => user.id
  }

  tenant_index = yamldecode(file("tenants.yaml"))
  defaults = local.tenant_index.defaults

  tenant_namespaces = flatten([
    for tenant, tenant_config in local.tenant_index.tenants : [
      for ns_name, ns_config in lookup(tenant_config, "namespaces", {}) : 
        "${tenant}-${ns_name}"
    ]
  ])

  all_tenants = keys(local.tenant_index.tenants)

  default_namespace_combinations = flatten([
    for tenant in local.all_tenants : [
      for default_ns, _ in local.defaults.namespaces :
        "${tenant}-${default_ns}"
    ]
  ])

  all_namespaces = distinct(concat(
    local.tenant_namespaces,
    local.default_namespace_combinations
  ))
}

output "namespace_list" {
  value = local.all_namespaces
}

resource "kubernetes_namespace" "mgmt_namespace" {
  metadata {
    name = "shoal-mgmt"
  }
}

// this has to run at the start, since we need to pre-provision users
module "tenant_projects" {
  for_each = local.project_user_map
  source = "./modules/rancher_project"

  project_prefix = "tenant"
  project_name   = each.key
  tenant_map     = { (each.key) = each.value }
  cluster_id     = data.rancher2_cluster.tetra.id
}

module "tenant_namespaces" {
  for_each = toset(local.all_namespaces)
  source = "./modules/rancher_namespace"

  project_id        = module.tenant_projects[split("-", each.key)[0]].project_id

  tenant_id         = local.project_user_map[split("-", each.key)[0]]
  tenant_name       = split("-", each.key)[0]

  namespace_prefix  = local.tenant_index.tenants[split("-", each.key)[0]]["short"]
  namespace_name    = split("-", each.key)[1]

  // TODO: defaults, labels, etc

  depends_on = [module.tenant_projects, kubernetes_namespace.mgmt_namespace]
}