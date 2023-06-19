
variable "tags" {
  type = map(string)
  default = {
    responsible_team    = "Base Team"
    responsible_contact = "awesome_team@terraformization.io"
  }
}

variable "global_key_vault_name" { default = "kv-global-killsh-tf" }

variable "global_resource_group" { default = "rg-global-killsh-tf" }
