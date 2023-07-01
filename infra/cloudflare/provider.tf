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

  config_path = "../base/kubeconfig"
  # host                   = module.aks.host
  # client_certificate     = base64decode(module.aks.client_certificate)
  # client_key             = base64decode(module.aks.client_key)
  # cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)

}

provider "cloudflare" {
  email   = data.azurerm_key_vault_secret.cloudflare-email.value
  api_key = data.azurerm_key_vault_secret.cloudflare-token.value
}
