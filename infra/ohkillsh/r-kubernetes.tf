module "kubernetes_config" {
  source       = "git@github.com:ohkillsh/killsh-module-kubernetes-config?ref=main"
  cluster_name = "dev-killsh"
  kubeconfig   = module.aks.kube_config_raw

  list_namespace = [
    "test",
    "dev"
  ]

  registry_password = data.azurerm_key_vault_secret.acr_password.value
  registry_username = data.azurerm_key_vault_secret.acr_login.value
  registry_server   = data.azurerm_key_vault_secret.acr_url.value

  depends_on = [
    data.azurerm_key_vault_secret.acr_login,
    data.azurerm_key_vault_secret.acr_url,
    data.azurerm_key_vault_secret.acr_password,
    module.aks
  ]
}
