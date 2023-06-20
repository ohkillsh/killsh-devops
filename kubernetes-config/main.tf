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

resource "kubernetes_namespace" "test" {
  metadata {
    name = "apps"
  }
}

# resource "helm_release" "nginx_ingress" {
#   name = "nginx-ingress-controller"

#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "nginx-ingress-controller"

#   set {
#     name  = "service.type"
#     value = "ClusterIP"
#   }
# }

resource "local_file" "kubeconfig" {
  content  = var.kubeconfig
  filename = "${path.root}/kubeconfig"
}


resource "helm_release" "prometheus_operator" {
  name       = "prometheus-operator"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"

  values = [
    file("${path.module}/charts/values-prometheus.yaml")
  ]
}


resource "helm_release" "haproxy_ingress" {
  name       = "haproxy"
  repository = "https://haproxytech.github.io/helm-charts"
  chart      = "haproxytech"
  namespace  = "ingress"

  values = [
    file("${path.module}/charts/values-haproxy.yaml")
  ]

  depends_on = [helm_release.prometheus_operator]
}
