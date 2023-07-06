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

resource "null_resource" "deploy_argo" {
  triggers = {}

  provisioner "local-exec" {

    command = "kubectl create namespace argocd --kubeconfig ../base/kubeconfig && kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --kubeconfig ../base/kubeconfig"
  }
}

resource "null_resource" "argocd_app_1" {
  triggers = {}

  provisioner "local-exec" {
    command = "kubectl apply --kubeconfig ../base/kubeconfig -f ${path.root}/manifests/argocd/traefik-nginx-app.yaml"
  }

  depends_on = [null_resource.deploy_argo]
}


