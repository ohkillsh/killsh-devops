locals {
  gloval_kv_name = "kv-global-${var.project_name}-tf"
  global_rg      = "rg-global-${var.project_name}-tf"
  region         = "eastus"
}

resource "azurerm_resource_group" "aks" {
  name     = "rg-dev-aks"
  location = local.region

}

module "network" {
  source              = "git@github.com:ohkillsh/killsh-module-network.git?ref=main"
  vnet_name           = "vnet-aks-lab"
  resource_group_name = azurerm_resource_group.aks.name
  address_space       = "10.10.0.0/16"
  subnet_prefixes     = ["10.10.255.0/24", "10.10.0.0/20", "10.10.254.0/24"]
  subnet_names        = ["subnet-infra", "subnet-aks-pod", "subnet-bastion"]

  depends_on = [azurerm_resource_group.aks]
}

module "aks" {
  source                           = "git@github.com:ohkillsh/killsh-module-aks?ref=main"
  resource_group_name              = azurerm_resource_group.aks.name
  kubernetes_version               = "1.26.3"
  orchestrator_version             = "1.26.3"
  prefix                           = "killsh"
  cluster_name                     = "dev-killsh"
  os_disk_size_gb                  = 64
  enable_role_based_access_control = false
  enable_auto_scaling              = true
  enable_log_analytics_workspace   = true
  agents_min_count                 = 3
  agents_max_count                 = 3
  agents_size                      = "standard_b4ms"
  agents_max_pods                  = 110
  agents_pool_name                 = "exnodepool"
  agents_availability_zones        = ["1", "2", "3"]
  agents_type                      = "VirtualMachineScaleSets"

  agents_labels = {
    "nodepool" : "defaultnodepool"
  }

  agents_tags = {
    "Agent" : "defaultnodepoolagent"
  }

  vnet_subnet_id             = module.network.vnet_subnets[1] # POD network address
  network_plugin             = "azure"
  net_profile_dns_service_ip = "10.10.16.10"   # IP address of DNS service and should be the .10 of service CIDR
  net_profile_service_cidr   = "10.10.16.0/20" # A CIDR notation IP range from which to assign service cluster IPs.

  log_retention_in_days = 31

  depends_on = [module.network]
}

resource "azurerm_key_vault_secret" "kv_aks_kubeconfig" {
  name         = "aks-kubeconfig-raw"
  value        = module.aks.kube_config_raw
  key_vault_id = data.azurerm_key_vault.global_kv.id

  depends_on = [data.azurerm_key_vault.global_kv]
}

resource "local_file" "kubeconfig" {
  content  = module.aks.kube_config_raw
  filename = "${path.root}/kubeconfig"
}

