data "github_organization" "org" {
  name = "shoal-konst-fish"
}

output "org_members" {
  value = data.github_organization.org.users
}