// This section would be dependent on getting private access via vpn, other private access method
// but is not functional currently.  Expand on if time.

resource "azurerm_network_ddos_protection_plan" "my" {
  count               = var.private_cluster_enabled ? 1 : 0
  name                = local.ddos_plan_name
  resource_group_name = azurerm_resource_group.my.name
  location            = azurerm_resource_group.my.location
}

resource "azurerm_virtual_network" "my" {
  count               = var.private_cluster_enabled ? 1 : 0
  name                = local.virtual_network_name
  resource_group_name = azurerm_resource_group.my.name
  location            = azurerm_resource_group.my.location
  address_space       = var.virtual_network_address_space

  ddos_protection_plan {
    id     = var.private_cluster_enabled ? azurerm_network_ddos_protection_plan.my[0].id : null
    enable = true
  }

  lifecycle {
    ignore_changes = [tags]
  }

  tags = local.tags
}

resource "azurerm_subnet" "my" {
  count                = var.private_cluster_enabled ? 1 : 0
  name                 = local.subnet_name
  resource_group_name  = azurerm_resource_group.my.name
  virtual_network_name = var.private_cluster_enabled ? azurerm_virtual_network.my[0].name : null
  address_prefixes     = var.network_address_prefix

  lifecycle {
    create_before_destroy = true
  }
}