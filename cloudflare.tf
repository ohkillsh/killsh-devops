data "cloudflare_zone" "ohkillsh_win" {
  name = "ohkillsh.win"

  depends_on = [module.kubernetes_config]
}

# output "debug" {
#   value = module.kubernetes_config.ingress_public_ip
# }

resource "cloudflare_record" "aks_ingress" {
  zone_id = data.cloudflare_zone.ohkillsh_win.id
  name    = "ingress-dev-killsh"
  value   = "20.253.29.58" #module.kubernetes_config.ingress_public_ip
  type    = "A"
  proxied = true
  ttl     = 1

  depends_on = [data.cloudflare_zone.ohkillsh_win]
}


resource "cloudflare_record" "aks_app_web" {
  zone_id    = data.cloudflare_zone.ohkillsh_win.id
  name       = "app"
  value      = cloudflare_record.aks_ingress.hostname
  type       = "CNAME"
  ttl        = 1
  proxied    = true
  depends_on = [data.cloudflare_zone.ohkillsh_win]
}
