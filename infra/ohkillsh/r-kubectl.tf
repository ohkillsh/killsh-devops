module "k8s_config_manifests" {
  source = "git@github.com:ohkillsh/killsh-module-kubernetes-config.git//kubectl?ref=develop"
}
data "kubectl_file_documents" "app" {
  content = file("./manifests/argocd/traefik-nginx-app.yaml")
}

resource "kubectl_manifest" "traefik_nginx_app" {
  depends_on = [
    module.k8s_config_manifests
  ]
  count              = length(data.kubectl_file_documents.app.documents)
  yaml_body          = element(data.kubectl_file_documents.app.documents, count.index)
  
  override_namespace = "argocd"
}

