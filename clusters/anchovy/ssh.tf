data "external" "github_ssh_key" {
  program = ["bash", "-c", "curl -s https://github.com/${var.github_user}.keys | head -n 1 | jq --raw-input '{ssh_key: .}'"]
}