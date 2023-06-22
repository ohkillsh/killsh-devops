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
  chart            = "kubernetes-ingress"
  namespace        = "ingress"
  force_update     = true
  create_namespace = true
  version          = "1.30.6"

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name = "--namespace-whitelist"
    value = "dev"
  }
  
  values = [
    file("${path.module}/charts/values-haproxy.yaml")
  ]

  depends_on = [helm_release.prometheus_operator]
}

# resource "helm_release" "redis_commander" {
#   name       = "redis-commander"
#   repository = "https://github.com/joeferner/redis-commander/tree/master/k8s/helm-chart/"
#   chart      = "redis-commander"
#   version    = "0.1.12"

#   namespace        = "tshoot"
#   force_update     = true
#   create_namespace = true


#   values = []
#   # values = [
#   #   file("${path.module}/charts/values.yaml")
#   # ]

#   depends_on = [helm_release.prometheus_operator]

# }

# resource "helm_release" "nginx_test" {
#   name       = "nginx-test"
#   repository = "https://charts.bitnami.com/bitnami/"
#   chart      = "nginx"
#   version    = "15.0.2"

#   namespace        = "dev"
#   force_update     = true
#   create_namespace = true

#   depends_on = [helm_release.prometheus_operator]

# }

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  skip_crds        = true

  set {
    name  = "installCRDs"
    value = true
  }

  depends_on = []


}
