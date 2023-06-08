
variable "tags" {
  type = map(string)
  default = {
    responsible_team    = "Base Team"
    responsible_contact = "awesome_team@terraformization.io"
  }
}

