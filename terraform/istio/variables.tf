// todo

variable "mesh_id" {
  description = "The mesh ID."
  type        = string
  default     = "shoal"
}

variable "cluster_name" {
    description = "The name of the cluster."
    type        = string
    default     = "tetra"
}

variable "multicluster_enabled" {
    description = "Enable multi-cluster."
    type        = bool
    default     = false
}