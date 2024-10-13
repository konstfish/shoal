variable "longhorn_s3_access_key" {
  description = "The Access Key ID for the Longhorn S3 backup."
  type        = string
  sensitive   = true
}

variable "longhorn_s3_secret_key" {
  description = "The Secret Key for the Longhorn S3 backup."
  type        = string
  sensitive   = true
}

variable "longhorn_s3_endpoint" {
  description = "The S3 endpoint to use for Longhorn backups."
  type        = string
}

variable "longhorn_s3_bucket" {
  description = "The S3 bucket to use for Longhorn backups."
  type        = string
}