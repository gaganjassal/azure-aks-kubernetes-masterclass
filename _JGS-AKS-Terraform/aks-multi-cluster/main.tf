resource "azurerm_resource_group" "aks-masterclass" {
  name     = "aks-rg3"
  location = "canadacentral"
}

resource "azurerm_kubernetes_cluster" "myakscluster" {
  name                = "myakscluster"
  resource_group_name = azurerm_resource_group.aks-masterclass.name
  location            = azurerm_resource_group.aks-masterclass.location
  dns_prefix          = "myakscluster-dns"

  default_node_pool {
    name       = "agentpool"
    node_count = 1
    vm_size    = "Standard_D2s_v3"

    auto_scaling_enabled = true
    max_count            = 5
    min_count            = 1

  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    "Environment" = "Development"
  }
}