data "github_organization" "org" {
  name = "shoal-konst-fish"
}

data "github_team" "org_team_obligate" {
  slug = "obligate"
}

locals {
  user_map = { for user in data.github_organization.org.users : user.login => user }
}

data "github_user" "org_users" {
  for_each = local.user_map

  username = each.value.login
}

// request https://rancher.konst.fish/v1/management.cattle.io.users?exclude=metadata.managedFields
/* resource "rancher2_token" "temp_user_token" {
  description = "temp_user_token"
  ttl = 30
} */

data "http" "api_response" {
  url = "https://rancher.konst.fish/v1/management.cattle.io.users?exclude=metadata.managedFields"
  request_headers = {
    // Authorization = "Bearer ${rancher2_token.temp_user_token.token}"
    Authorization = "Bearer ${var.rancher_bearer_token}"
    Accept        = "application/json"
  }
}

locals {
  users_list = jsondecode(data.http.api_response.response_body)["data"]
  github_user_to_id_map = {
    for user in local.users_list :
    (one([for pid in user.principalIds : pid if can(regex("github_user://.*", pid))])) => user.id if length([for pid in user.principalIds : pid if can(regex("github_user://.*", pid))]) > 0
  }

  // depends_on = [ rancher2_project_role_template_binding.user_projects_binding ]
}

output "github_user_to_id_map" {
  value = local.github_user_to_id_map
}