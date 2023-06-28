variable "tags" {
  type = map(string)
  default = {
    responsible_team    = "Base Team"
    responsible_contact = "awesome_team@terraformization.io"
  }
}
variable "region" {
  default = "eastus"
}

variable "product_name" {
  default = "ohkillsh"
}

variable "environment_name" {
  default = "global"
}

