
output "ingress_public_ip" {
  value = data.kubernetes_service.haproxy_loadbalancer_ip.status.0.load_balancer.0.ingress.0.hostname
}
