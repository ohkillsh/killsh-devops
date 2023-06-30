
variable "tags" {
  type = map(string)
  default = {
    responsible_team    = "Base Team"
    responsible_contact = "awesome_team@terraformization.io"
  }
}

# From: backend-support
variable "project_name" {
  type = string
  default = "ohkillsh"
  description = "Name of the project"
}


# Provider Auth

variable "cloudflare_email" {}
variable "cloudflare_api_token" {}