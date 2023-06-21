
resource "kubernetes_config_map_v1_data" "cfg_coredns" {

  force = true

  metadata {
    name      = "coredns"
    namespace = "kube-system"
  }

  data = {
    "Corefile" = <<EOF
.:53 {
    errors
    health
    kubernetes cluster.local in-addr.arpa ip6.arpa {
        pods insecure
        fallthrough in-addr.arpa ip6.arpa
    }
    prometheus :9153
    forward . /etc/resolv.conf
    cache 30
    loop
    reload
    loadbalance
}
ohkillsh.win:53 {
    errors
    cache 30
    forward . 10.15.0.4 10.15.0.5 {
      policy random
      health_check 5s 
    }
}
EOF    
  }


}
