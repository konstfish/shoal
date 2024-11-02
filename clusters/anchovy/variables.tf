variable "github_user" {
  default = "konstfish"
}

// oracle cloud
variable "ocid_compartment_id"{
    description = "oicd compartment id"
}

variable "oicd_region" {
  default = "eu-frankfurt-1"
}

variable "" {
  
}

variable "amd_shape" {
  default = "VM.Standard.E2.1.Micro"
}

variable "amd_count" {
  default = 2
}

variable "arm_shape" {
  default = "VM.Standard.A1.Flex"
}

variable "arm_count" {
  default = 2
}

// talos
variable "cluster_name" {
  type    = string
  default = "anchovy"
}

variable "control_plane_count" {
  type        = number
  default     = 1
  description = "Number of control plane nodes to configure (should match amd_count for control plane nodes)"
}