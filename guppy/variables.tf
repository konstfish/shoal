// Setup
variable "github_usernames" {
  description = "List of GitHub usernames"
  type        = list(string)
}

// Cluster Settings
/// General
variable "cluster_name" {
  description = "The name of the cluster."
  type        = string
  default     = "tetra"
}

variable "cluster_k3s_version" {
  description = "Cluster version"
  type        = string
  default     = "v1.29.7+k3s1"
}

// REPLACE WITH YOUR OWN TOKEN
variable "cluster_token" {
  description = "Cluster token"
  type        = string
  default     = "asdf"
}

// Cloudflare
variable "cloudflare_api_token" {
  description = "The API Token for Cloudflare."
  type        = string
  sensitive   = true
}

variable "cloudflare_acount_id" {
  description = "The Cloudflare Account ID."
  type        = string
}