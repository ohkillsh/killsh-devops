# killsh-devops

Ohkillsh DevOps Infrastructure projet

## Configure kubectl

```bash
export KUBECONFIG=${PWD}/kubeconfig

az aks install-cli

kubectl get nodes 
```

### Create app test to run in K8s

```ỳaml
resource "helm_release" "nginx" {
  name       = "nginx"
  repository = "https://charts.bitnami.com/bitnami/"
  chart      = "nginx"
  version    = "15.0.2"

  namespace        = "dev"
  force_update     = true
  create_namespace = true

  depends_on = [module.aks]

  provider = helm.test
}

```