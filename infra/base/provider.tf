terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      #version = ""
    }

  }
  backend "azurerm" {
    resource_group_name  = "rg-global-ohkillsh-tf"
    storage_account_name = "stgtfglobalohkillsh"
    container_name       = "terraform"
    key                  = "ohkillsh.infra.tfstate"
  }

}

provider "azurerm" {
  features {}

}
