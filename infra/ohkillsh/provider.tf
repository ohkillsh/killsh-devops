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

    helm = {
      source = "hashicorp/helm"
      #version = ""
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~>1.14.0"
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

provider "helm" {
  debug = true
  alias = "test"
  kubernetes {
    host                   = module.aks.host
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args = [
        "get-token",
        "--client-id", data.azurerm_key_vault_secret.tf-client-id.value,
        "--client_secret", data.azurerm_key_vault_secret.tf-client-secret.value,
        "--tenant-id", data.azurerm_key_vault_secret.tf-tenant-id.value,
        "--login", "spn",
        "--environment", "AzurePublicCloud",
      ]
      command = "/usr/local/bin/kubelogin"
    }
  }
}

provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)

}

provider "helm" {
  debug = true
  kubernetes {
    host                   = module.aks.host
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_token
}


provider "kubectl" {
  apply_retry_count      = 5
  host                   = module.aks.host
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  load_config_file       = false

  # exec {
  #   api_version = "client.authentication.k8s.io/v1beta1"
  #   args = [
  #     "get-token",
  #     "--client-id", data.azurerm_key_vault_secret.tf-client-id.value,
  #     "--client_secret", data.azurerm_key_vault_secret.tf-client-secret.value,
  #     "--tenant-id", data.azurerm_key_vault_secret.tf-tenant-id.value,
  #     "--login", "spn",
  #     "--environment", "AzurePublicCloud",
  #   ]
  #   command = "/usr/local/bin/kubelogin"
  # }
}