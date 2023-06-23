data "cloudflare_zone" "ohkillsh_win" {
  name = "ohkillsh.win"

  depends_on = [module.kubernetes_config]
}

data "kubernetes_resource" "loadbalancer_ingress_aks" {
  api_version = "v1"
  kind        = "Service"

  metadata {
    name      = "traefik"
    namespace = "ingress"
  }
}


resource "cloudflare_record" "aks_ingress" {
  zone_id = data.cloudflare_zone.ohkillsh_win.id
  name    = "ingress-dev-killsh"
  value   = data.kubernetes_resource.loadbalancer_ingress_aks.object.status.loadBalancer.ingress.0.ip
  type    = "A"
  proxied = true
  ttl     = 1

  depends_on = [data.cloudflare_zone.ohkillsh_win]

  lifecycle {
    ignore_changes = [
      zone_id
    ]
  }
}


resource "cloudflare_record" "aks_app_web" {
  zone_id    = data.cloudflare_zone.ohkillsh_win.id
  name       = "app"
  value      = cloudflare_record.aks_ingress.hostname
  type       = "CNAME"
  ttl        = 1
  proxied    = true
  depends_on = [data.cloudflare_zone.ohkillsh_win]

  lifecycle {
    ignore_changes = [
      zone_id
    ]
  }
}
