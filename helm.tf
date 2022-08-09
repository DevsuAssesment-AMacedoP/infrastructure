provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.devsu-cluster.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.devsu-cluster.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.devsu-cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.devsu-cluster.kube_config.0.cluster_ca_certificate)
  }
}

locals {
  external_dns_vars = {
    log_level            = "debug"
    cloudflare_api_token = var.cloudflare_api_token
    domain               = var.domain
  }

  external_dns_values = templatefile(
    "${path.module}/templates/external_dns_values.yaml.tmpl",
    local.external_dns_vars
  )
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  namespace        = "external-dns"
  create_namespace = true
  version          = "6.7.4"
  values           = [local.external_dns_values]
}

resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "nginx-ingress-controller"
  namespace        = "ingress-nginx"
  create_namespace = true
  version          = "9.2.27"

  set {
    name = "publishService.enabled"
    value = "true"
  }
}

resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true
  version          = "1.9.1"

  set {
    name = "installCRDs"
    value = "true"
  }
}
