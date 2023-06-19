terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      #version = "2.21.1"
    }

    azurerm = {
      source = "hashicorp/azurerm"
      #version = "~>2.0"
    }

  }

}

provider "azurerm" {
  features {}
}


# provider "kubernetes" {
#   config_path    = "~/.kube/config"
#   config_context = "my-context"
# }