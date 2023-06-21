terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.21.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.0"
    }
  }
}

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


resource "helm_release" "prometheus_operator" {
  name             = "prometheus-operator"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  force_update     = true
  create_namespace = true

  values = [
    file("${path.module}/charts/values-prometheus.yaml")
  ]
}

resource "helm_release" "haproxy_ingress" {
  name             = "haproxy"
  repository       = "https://haproxytech.github.io/helm-charts"
  chart            = "haproxy"
  namespace        = "ingress"
  force_update     = true
  create_namespace = true

  values = [
    file("${path.module}/charts/values-haproxy.yaml")
  ]

  depends_on = [helm_release.prometheus_operator]
}

