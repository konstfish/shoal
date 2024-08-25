data "github_organization" "org" {
  name = "shoal-konst-fish"
}

data "github_team" "org_team_obligate" {
  slug = "obligate"
}