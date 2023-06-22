data "kubernetes_service" "haproxy_loadbalancer_ip" {
  metadata {
    name = "haproxy-kubernetes-ingress"
  }
}
