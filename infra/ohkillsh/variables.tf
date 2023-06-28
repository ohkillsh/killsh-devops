
variable "tags" {
  type = map(string)
  default = {
    responsible_team    = "Base Team"
    responsible_contact = "awesome_team@terraformization.io"
  }
}

# From: backend-support
variable "global_key_vault_name" {}
variable "global_resource_group" {}

# Provider Auth

variable "cloudflare_email" {}
variable "cloudflare_api_token" {}