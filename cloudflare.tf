data "cloudflare_zone" "ohkillsh_win" {
  name = "ohkillsh.win"

  depends_on = [module.kubernetes_config]
}

#app.ohkillsh.win

resource "cloudflare_record" "aks_ingress" {
  zone_id = data.cloudflare_zone.ohkillsh_win.id
  name    = "ingress-dev-killsh"
  value   = "1.1.1.1"
  type    = "A"
  proxied = true
  ttl     = 3600

  depends_on = [data.data.cloudflare_zone.ohkillsh_win]
}


resource "cloudflare_record" "aks_app_web" {
  zone_id = data.cloudflare_zone.ohkillsh_win.id
  name    = "app"
  value   = cloudflare_record.aks_ingress.hostname
  type    = "CNAME"
  ttl     = 3600

  depends_on = [data.data.cloudflare_zone.ohkillsh_win]
}
