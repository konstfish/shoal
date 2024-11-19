// github
variable "gh_token" {
  description = "GitHub API Token"
  type        = string
  sensitive   = true
}

variable "gh_oauth_client_id" {
  description = "GitHub OAuth Client ID"
  type        = string
  sensitive   = true
}

variable "gh_oauth_client_secret" {
  description = "GitHub OAuth Client Secret"
  type        = string
  sensitive   = true
}

// rancher
variable "rancher_api_url" {
  description = "Rancher API URL"
  type        = string
  default     = "https://rancher.konst.fish"
}

variable "rancher_access_key" {
  description = "Rancher Access Key"
  type        = string
  sensitive   = true
}

variable "rancher_secret_key" {
  description = "Rancher Secret Key"
  type        = string
  sensitive   = true
}

variable "rancher_bearer_token" {
  description = "Rancher Bearer Token"
  type        = string
  sensitive   = true
}

// tenants
/*variable "tenant_index" {

  type = map(object({
    short  = string
    namespaces = map(object({
      name = string
      resources = map(object({
        limits_cpu       = string
        limits_memory    = string
        requests_storage = string
      }))
    }))
  }))
  default = null
}*/