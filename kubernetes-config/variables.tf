# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "cluster_name" {
  type = string
}

variable "kubeconfig" {
  type = string
}

variable "list_namespace" {
  type    = list(string)
  default = ["dev", "uat", "prd"]
}


variable "registry_email" { default = null }

variable "registry_password" { default = null }

variable "registry_username" { default = null }

variable "registry_server" { default = null }


