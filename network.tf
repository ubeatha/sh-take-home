resource "azurerm_network_ddos_protection_plan" "my" {
  name                = local.ddos_plan_name
  resource_group_name = azurerm_resource_group.my.name
  location            = azurerm_resource_group.my.location
}

resource "azurerm_virtual_network" "my" {
  name                = local.virtual_network_name
  resource_group_name = azurerm_resource_group.my.name
  location            = azurerm_resource_group.my.location
  address_space       = var.virtual_network_address_space

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.my.id
    enable = true
  }

  lifecycle {
    ignore_changes = [tags, ]
  }

  tags = local.tags
}

resource "azurerm_subnet" "this" {
  name                 = local.subnet_name
  resource_group_name  = azurerm_resource_group.my.name
  virtual_network_name = azurerm_virtual_network.my.name
  address_prefixes     = var.network_address_prefix

  lifecycle {
    create_before_destroy = true
  }
}