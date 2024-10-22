variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "project_prefix" {
  description = "Prefix for the project name"
  type        = string
  default     = ""
}

variable "tenant_map" {
  description = "Map of Tenants & GitHub IDs"
  type        = map(string)
}

variable "cluster_id" {
  description = "ID of the target cluster"
  type        = string
}