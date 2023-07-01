terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      #version = ""
    }

    azurerm = {
      source = "hashicorp/azurerm"
      #version = ""
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }

  }
  backend "azurerm" {
    resource_group_name  = "rg-global-ohkillsh-tf"
    storage_account_name = "stgtfglobalohkillsh"
    container_name       = "terraform"
    key                  = "ohkillsh.cloudflare.tfstate"
  }

}

provider "azurerm" {
  features {}

}

provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)

}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_token
}
