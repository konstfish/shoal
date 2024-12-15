variable "tenant_name" {
  description = "Name of the tenant"
  type        = string
}

variable "tenant_id" {
  description = "rancher user id"
  type        = string
}

variable "namespace_prefix" {
  description = "Prefix for the namespace"
  type        = string
}

variable "tenant_namespaces" {
  description = "Namespaces"
}