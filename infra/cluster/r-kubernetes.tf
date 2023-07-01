module "kubernetes_config2" {
  source       = "git@github.com:ohkillsh/killsh-module-kubernetes-config.git//kubernetes?ref=main"
  cluster_name = "dev-killsh"

  list_namespace = ["test", "dev"]

  registry_password = data.azurerm_key_vault_secret.acr_password.value
  registry_username = data.azurerm_key_vault_secret.acr_login.value
  registry_server   = data.azurerm_key_vault_secret.acr_url.value

  depends_on = [
    data.azurerm_key_vault_secret.acr_login,
    data.azurerm_key_vault_secret.acr_url,
    data.azurerm_key_vault_secret.acr_password
  ]
}

module "helm_config" {
  source = "git@github.com:ohkillsh/killsh-module-kubernetes-config.git//helm?ref=main"
}

module "k8s_config_manifests" {
  source = "git@github.com:ohkillsh/killsh-module-kubernetes-config.git//kubectl?ref=main"

  depends_on = [module.helm_config]
}

data "kubectl_file_documents" "argocd_apps" {
  content = file("./manifests/argocd/traefik-nginx-app.yaml")
}

resource "kubectl_manifest" "argocd_apps" {
  
  for_each = data.kubectl_file_documents.argocd_apps.manifests
  yaml_body = each.value

  depends_on = [
    module.k8s_config_manifests,
    data.kubectl_file_documents.argocd_apps
  ]

}

