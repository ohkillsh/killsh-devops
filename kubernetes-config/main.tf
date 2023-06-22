resource "kubernetes_namespace" "main" {
  for_each = toset(var.list_namespace)
  metadata {
    name = each.value
  }
}


resource "kubernetes_secret_v1" "secret_acr" {
  for_each = toset(var.list_namespace)

  metadata {
    name      = "docker-cfg"
    namespace = each.value
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.registry_server}" = {
          "username" = var.registry_username
          "password" = var.registry_password
          #"email"    = var.registry_email
          "auth" = base64encode("${var.registry_username}:${var.registry_password}")
        }
      }
    })
  }

  depends_on = [kubernetes_namespace.main]
}


resource "local_file" "kubeconfig" {
  content  = var.kubeconfig
  filename = "${path.root}/kubeconfig"
}




