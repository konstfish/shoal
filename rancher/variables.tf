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
variable "tenant_list" {
  description = "List of Tenants"
  type = map(object({
    shortname  = string
    github_uid = string
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
}

variable "playground_resources" {
  description = "Default Tenant Limit"
  type = object({
    limits_cpu       = string
    limits_memory    = string
    requests_storage = string
  })

  default = {
    limits_cpu       = "2000m"
    limits_memory    = "2000Mi"
    requests_storage = "30Gi"
  }
}