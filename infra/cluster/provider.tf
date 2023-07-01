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

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~>1.14.0"
    }

  }
  backend "azurerm" {
    resource_group_name  = "rg-global-ohkillsh-tf"
    storage_account_name = "stgtfglobalohkillsh"
    container_name       = "terraform"
    key                  = "ohkillsh.cluster.tfstate"
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

provider "helm" {

  # kubernetes {
  #   host                   = module.aks.host
  #   client_certificate     = base64decode(module.aks.client_certificate)
  #   client_key             = base64decode(module.aks.client_key)
  #   cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  # }

  kubernetes {
    config_path = "../base/kubeconfig"
  }

}

provider "kubectl" {

  config_path       = "../base/kubeconfig"
  apply_retry_count = 5
  load_config_file  = true


  # host                   = module.aks.host
  # cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  # client_certificate     = base64decode(module.aks.client_certificate)
  # client_key             = base64decode(module.aks.client_key)
  #load_config_file        = false

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

# provider "helm" {
#   debug = true
#   alias = "test"
#   kubernetes {
#     host                   = module.aks.host
#     client_certificate     = base64decode(module.aks.client_certificate)
#     client_key             = base64decode(module.aks.client_key)
#     cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)

#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args = [
#         "get-token",
#         "--client-id", data.azurerm_key_vault_secret.tf-client-id.value,
#         "--client_secret", data.azurerm_key_vault_secret.tf-client-secret.value,
#         "--tenant-id", data.azurerm_key_vault_secret.tf-tenant-id.value,
#         "--login", "spn",
#         "--environment", "AzurePublicCloud",
#       ]
#       command = "/usr/local/bin/kubelogin"
#     }
#   }
# }