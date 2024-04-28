data "github_organization" "org" {
  name = "shoal-konst-fish"
}

locals {
  user_map = { for user in data.github_organization.org.users : user.login => user }
}

data "github_user" "org_users" {
  for_each = local.user_map

  username = each.value.login
}