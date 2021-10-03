terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "random" {
}

provider "kubernetes" {
  host                   = "${azurerm_kubernetes_cluster.my.kube_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.my.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.my.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.my.kube_config.0.cluster_ca_certificate)}"
}