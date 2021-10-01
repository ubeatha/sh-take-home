data "azurerm_kubernetes_service_versions" "current" {
  location        = azurerm_resource_group.my.location
  include_preview = false
}



resource "azurerm_kubernetes_cluster" "my" {
  name                            = local.aks_cluster_name
  location                        = azurerm_resource_group.my.location
  resource_group_name             = azurerm_resource_group.my.name
  dns_prefix                      = local.aks_cluster_name
  kubernetes_version              = var.kubernetes_version != null ? var.kubernetes_version : data.azurerm_kubernetes_service_versions.current.latest_version
  private_cluster_enabled         = var.private_cluster_enabled
  api_server_authorized_ip_ranges = var.api_authorized_ips

  default_node_pool {
    name                = "default"
    vm_size             = var.vm_size
    enable_auto_scaling = true
    node_count          = var.node_count
    max_count           = var.max_count
    min_count           = var.min_count
    vnet_subnet_id      = var.private_cluster_enabled ? azurerm_subnet.my[0].id : null
    max_pods            = var.max_pods
  }

  addon_profile {
    // azure_policy {
    //   enabled = true
    // }
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.my.id
    }
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control {
    enabled = true
  }

  // linux_profile {
  //   admin_username = var.admin_ssh_key.username

  //   ssh_key {
  //     key_data = var.admin_ssh_key.public_key
  //   }
  // }

  // network_profile {
  //   network_plugin    = "kubnet"
  // }

  tags = local.tags

  lifecycle {
    ignore_changes = [tags, default_node_pool[0].node_count]
  }

}