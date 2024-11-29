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
  type        = string
}

// labels
variable "billing" {
  description = "Billing label"
  type        = string
  default     = "false"
}

variable "namespace_config" {
  description = "map of namespace configuration"
}