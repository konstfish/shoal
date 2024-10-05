variable "nfs_server" {
  description = "The NFS server to use for persistent storage."
  type        = string
  default     = "10.0.1.1"
}

variable "nfs_path" {
  description = "The NFS path to use for persistent storage."
  type        = string
  default     = "/mnt/md0/stor/k3s"
}

variable "nfs_mount_options" {
  description = "The mount options to use for the NFS volume."
  type        = string
  default     = "rw,rsize=32768,wsize=32768,timeo=600"
}