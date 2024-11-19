variable "project_id" {
  description = "ID of the target project"
  type        = string
}

variable "namespace_prefix" {
  description = "Prefix for the namespace name"
  type        = string
  default     = ""
}

variable "namespace_postfix" {
  description = "Postfix for the namespace name"
  type        = string
  default     = ""
}

variable "namespace_name" {
  description = "Name of the namespace"
  type        = string
}

variable "tenant_name" {
  description = "Name of the tenant"
  type        = string
}

variable "tenant_id" {
  description = "github uid"
  type = string
}

// labels
variable "billing" {
  description = "Billing label"
  type        = string
  default     = "false"
}

variable "extra_labels" {
  description = "additional namespace labels"
  type        = map(string)
  default     = {}
}

// resources
variable "namespace_resources" {
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

variable "container_resources" {
  description = "Default Tenant Limit"
  type = object({
    limits_cpu      = string
    limits_memory   = string
    requests_cpu    = string
    requests_memory = string
  })

  default = {
    limits_cpu      = "200m"
    limits_memory   = "256Mi"
    requests_cpu    = "100m"
    requests_memory = "128Mi"
  }
}