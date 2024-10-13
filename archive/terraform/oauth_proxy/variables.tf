variable "oauth_domain" {
    description = "OAuth domain"
    type        = string
    default     = "sso.konst.fish"
}

variable "oauth_class" {
    description = "OAuth class"
    type        = string
    default     = "zero"
}

variable "oauth_github_team" {
  description = "OAuth GitHub team"
  type        = string
  default     = ""
}

// secure
variable "oauth_client_id" {
  description = "OAuth client ID"
  type        = string
}

variable "oauth_client_secret" {
  description = "OAuth client secret"
  type        = string
  sensitive   = true
}

variable "oauth_cookie_secret" {
  description = "OAuth cookie secret"
  type        = string
  sensitive   = true
}