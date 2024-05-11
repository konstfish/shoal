// auth config
resource "rancher2_auth_config_github" "github" {
  client_id             = var.gh_oauth_client_id
  client_secret         = var.gh_oauth_client_secret
  access_mode           = "required"
  allowed_principal_ids = ["github_org://${data.github_organization.org.id}"]
}

// clusters
/// data for now
data "rancher2_cluster" "guppy" {
  name = "guppy"
}

data "rancher2_cluster" "tetra" {
  name = "tetra"
}

/*resource "rancher2_cluster" "guppy" {
  name = "guppy"
}

resource "rancher2_cluster" "tetra" {
  name = "tetra"
}*/

// settings
resource "rancher2_setting" "show_local_clusters" {
  name       = "hide-local-cluster"
  value      = "true"
}

// request https://rancher.konst.fish/v1/management.cattle.io.users?exclude=metadata.managedFields
resource "rancher2_token" "temp_user_token" {
  description = "temp_user_token"
  ttl = 30
}

data "http" "api_response" {
  url = "https://rancher.konst.fish/v1/management.cattle.io.users?exclude=metadata.managedFields"
  request_headers = {
    Authorization = "Bearer ${rancher2_token.temp_user_token.token}"
    Accept        = "application/json"
  }
}

locals {
  users_list = jsondecode(data.http.api_response.response_body)["data"]
  github_user_to_id_map = {
    for user in local.users_list :
      (one([for pid in user.principalIds : pid if can(regex("github_user://.*", pid))])) => user.id if length([for pid in user.principalIds : pid if can(regex("github_user://.*", pid))]) > 0
  }
}

output "github_user_to_id_map" {
  value = local.github_user_to_id_map
}