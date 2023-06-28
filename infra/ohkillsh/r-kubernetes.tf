module "kubernetes_config" {
  source       = "git@github.com:ohkillsh/killsh-module-kubernetes-config.git//kubernetes?ref=main"
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

module "helm_config" {
  source       = "git@github.com:ohkillsh/killsh-module-kubernetes-config.git//helm?ref=main"
}

module "k8s_config_manifests" {
  source = "git@github.com:ohkillsh/killsh-module-kubernetes-config.git//kubectl?ref=main"

  depends_on = [ module.helm_config ]
}
data "kubectl_file_documents" "app" {
  content = file("./manifests/argocd/traefik-nginx-app.yaml")
}

resource "kubectl_manifest" "traefik_nginx_app" {
  depends_on = [
    module.k8s_config_manifests
  ]
  count     = length(data.kubectl_file_documents.app.documents)
  yaml_body = element(data.kubectl_file_documents.app.documents, count.index)

  override_namespace = "argocd"
}

