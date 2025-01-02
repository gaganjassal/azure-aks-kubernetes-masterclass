resource "azurerm_resource_group" "aks-masterclass" {
  name     = "aks-masterclass"
  location = "canadacentral"

}

resource "azurerm_resource_group" "acr-demo" {
  name     = "acr-demo"
  location = "canadacentral"

}

# terraform import azurerm_resource_group.aks-masterclass /subscriptions/SUBSCRIPTION_ID/resourceGroups/aks-masterclass

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
output "aks-get-credentials" {
  value = "az aks get-credentials -g ${azurerm_resource_group.aks-masterclass.name} -n ${azurerm_kubernetes_cluster.myakscluster.name}"
}

# resource "azurerm_container_registry" "jgsacr" {
#   name                = "jgsacr"
#   resource_group_name = azurerm_resource_group.acr-demo.name
#   location            = azurerm_resource_group.acr-demo.location
#   sku                 = "Basic"
#   admin_enabled       = true
# }

# output "acr_server" {
#   value = azurerm_container_registry.jgsacr.login_server
# }
# output "acr_id" {
#   value = azurerm_container_registry.jgsacr.id
# }

# resource "azurerm_role_assignment" "acrpull" {
#   scope                = azurerm_container_registry.jgsacr.id
#   role_definition_name = "AcrPull"
#   principal_id         = azurerm_kubernetes_cluster.myakscluster.identity[0].principal_id
# }

# resource "azurerm_role_assignment" "acrpull" {
#   scope                = azurerm_container_registry.jgsacr.id
#   role_definition_name = "AcrPull"
#   principal_id         = azurerm_kubernetes_cluster.myakscluster.kubelet_identity[0].object_id
# }

# terraform import azurerm_kubernetes_cluster.myakscluster /subscriptions/SUBSCRIPTION_ID/resourceGroups/aks-masterclass/providers/Microsoft.ContainerService/managedClusters/myakscluster