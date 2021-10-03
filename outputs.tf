output "resource_group_name" {
  value = azurerm_resource_group.my.name
}

output "resource_group_id" {
  value = azurerm_resource_group.my.id
}

output "storage_account_name" {
  value = azurerm_storage_account.my.name
}

output "storage_account_id" {
  value = azurerm_storage_account.my.id
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.my.id
}

output "network_name" {
  value = var.private_cluster_enabled ? azurerm_virtual_network.my[0].name : ""
}

output "network_id" {
  value = var.private_cluster_enabled ? azurerm_virtual_network.my[0].id : ""
}

output "subnet_name" {
  value = var.private_cluster_enabled ? azurerm_subnet.my[0].name : ""
}

output "subnet_id" {
  value = var.private_cluster_enabled ? azurerm_subnet.my[0].id : ""
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.my.name
}

output "kubernetes_cluster_id" {
  value = azurerm_kubernetes_cluster.my.id
}

output "kubernetes_cluster" {
  value = azurerm_kubernetes_cluster.my
  sensitive   = true
}

output "cluster_authorized_ranges" {
  value = azurerm_kubernetes_cluster.my.api_server_authorized_ip_ranges
}