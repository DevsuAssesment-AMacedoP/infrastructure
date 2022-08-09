###
# AKS
###

resource "azurerm_resource_group" "devsu-rg" {
  name     = "devsu"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "devsu-cluster" {
  name                = "devsu-aks-cluster"
  location            = azurerm_resource_group.devsu-rg.location
  resource_group_name = azurerm_resource_group.devsu-rg.name
  dns_prefix = "devsu-cluster"

  default_node_pool {
    name = "default"
    node_count = 1
    vm_size = "Standard_DS3_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.22"

  network_profile {
    load_balancer_sku = "standard"
    network_plugin = "kubenet"
  }
}

output "kube_config" {
    value = azurerm_kubernetes_cluster.devsu-cluster.kube_config_raw
    sensitive = true
}
