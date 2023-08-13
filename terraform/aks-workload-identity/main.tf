provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "time_sleep" "wait_10_seconds" {
  depends_on = [azurerm_resource_group.rg]
  create_duration = "10s"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_cluster_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_cluster_name
  workload_identity_enabled = true
  oidc_issuer_enabled = true

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

   default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_DS2_v2"
  }

  network_profile {
    network_plugin = "azure"
  }

   tags = {
    Environment = "PoC"
  }


}
