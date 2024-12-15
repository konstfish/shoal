locals {
  project_user_map = {
    for login, user in data.github_user.org_users :
    user.username => user.id
  }

  tenant_index = yamldecode(file("tenants.yaml"))
  defaults     = local.tenant_index.defaults

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

  rancher_user_map = {
    for tenant, tenant_config in local.tenant_index.tenants :
    tenant => tenant_config["rancher"]
  }
}

output "namespace_list" {
  value = local.all_namespaces
}

resource "kubernetes_namespace" "mgmt_namespace" {
  metadata {
    name = "shoal-mgmt"
  }

  lifecycle {
    ignore_changes = [
      metadata,
    ]
  }
}

// primary rbac
resource "kubernetes_manifest" "project_tenant_role" {
  provider = kubernetes.barracuda

  manifest = yamldecode(file("${path.module}/kubernetes/project-tenant.yaml"))
  field_manager {
    force_conflicts = true
  }
}

// this has to run at the start, since we need to pre-provision users
module "tenant_projects" {
  for_each = local.project_user_map
  source   = "./modules/rancher_project"

  project_prefix = "tenant"
  project_name   = each.key
  tenant_map     = { (each.key) = each.value }
  cluster_id     = data.rancher2_cluster.tetra.id

  depends_on = [kubernetes_manifest.project_tenant_role]
}

// todo: find a way to clean this up, actually unreadable
module "tenant_namespaces" {
  for_each = toset(local.all_namespaces)
  source   = "./modules/rancher_namespace"

  project_id = module.tenant_projects[split("-", each.key)[0]].project_id

  tenant_id   = local.project_user_map[split("-", each.key)[0]]
  tenant_name = split("-", each.key)[0]

  namespace_prefix = local.tenant_index.tenants[split("-", each.key)[0]]["short"]
  namespace_name   = split("-", each.key)[1]

  // honestly this might be the best thing i've ever written
  // note from 3 weeks later, i have no clue what i did here or how this works on first glance
  namespace_config = lookup(
    lookup(local.tenant_index.tenants[split("-", each.key)[0]], "namespaces", {}),
    split("-", each.key)[1],
    local.defaults["namespaces"]["playground"],
  )

  depends_on = [module.tenant_projects, kubernetes_namespace.mgmt_namespace]
}

// fleet
module "tenant_fleet_workspaces" {
  for_each = local.rancher_user_map
  source   = "./modules/rancher_fleet_workspace"

  tenant_name = each.key
  tenant_id   = each.value

  namespace_prefix = local.tenant_index.tenants[each.key]["short"]
  tenant_namespaces = [
    for ns in local.all_namespaces: 
    split("-", ns)[1]
    if startswith(ns, each.key)
  ]

  providers = {
    kubernetes = kubernetes.barracuda
    helm       = helm.barracuda
  }

  depends_on = [module.tenant_projects]
}