data "azurerm_client_config" "my" {
}

resource "random_string" "my" {
  length  = 10
  upper   = false
  special = false
}

locals {
  resource_group_name  = "${var.base_name}-${var.environment}-resource-group"
  storage_account_name = "${var.base_name}${var.environment}${random_string.my.result}"
  law_name             = "${var.base_name}-${var.environment}-law-${data.azurerm_client_config.my.subscription_id}"
  ddos_plan_name       = "${var.base_name}-${var.environment}-ddos-pp"
  virtual_network_name = "${var.base_name}-${var.environment}-vnet"
  subnet_name          = "${var.base_name}-${var.environment}-subnet"
  tags = {
    app        = var.base_name
    creator    = "terraform"
    created_on = formatdate("YYYY MMM DD hh:mm ZZZ", timestamp())
  }
}

resource "azurerm_resource_group" "my" {
  name     = local.resource_group_name
  location = var.location

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags, ]
  }

  tags = local.tags

}

resource "azurerm_storage_account" "my" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.my.name
  location                 = azurerm_resource_group.my.location
  account_tier             = var.storage_account_tier
  account_kind             = "StorageV2"
  account_replication_type = var.storage_replication_type

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [tags, ]
  }

  tags = local.tags
}

resource "azurerm_log_analytics_workspace" "my" {
  name                = local.law_name
  resource_group_name = azurerm_resource_group.my.name
  location            = azurerm_resource_group.my.location
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "my" {
  solution_name         = "ContainerInsights"
  resource_group_name   = azurerm_resource_group.my.name
  location              = azurerm_resource_group.my.location
  workspace_resource_id = azurerm_log_analytics_workspace.my.id
  workspace_name        = azurerm_log_analytics_workspace.my.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

