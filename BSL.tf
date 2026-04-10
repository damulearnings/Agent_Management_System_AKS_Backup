# 1. Define the Azure Storage Resources
resource "azurerm_resource_group" "velero-bslda" {
  name     = "velero-BSL-backup-damu"
  location = "East US"
}

resource "azurerm_storage_account" "velero-BSL-acc" {
  name                     = "velerobslstorageacc"
  resource_group_name      = azurerm_resource_group.velero-bslda.name
  location                 = azurerm_resource_group.velero-bslda.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "velero-bsl-d" {
  name                  = "velero-bsl-bkp"
  storage_account_name  = azurerm_storage_account.velero-BSL-acc.name
  container_access_type = "private"
}

# 2. Define the velero-BSL-BSL BackupStorageLocation (BSL) via Kubernetes Provider
#resource "kubernetes_manifest" "velero-BSL_bsl" {
#  manifest = {
#    "apiVersion" = "velero.io/v1"
#    "kind"       = "BackupStorageLocation"
#    "metadata" = {
#      "name"      = "default"
#      "namespace" = "velero"
#    }
#    "spec" = {
#      "provider" = "azure"
#      "objectStorage" = {
#        "bucket" = azurerm_storage_container.velero-BSL.name
#      }
#      "config" = {
#        "resourceGroup"  = azurerm_resource_group.velero-BSL.name
#        "storageAccount" = azurerm_storage_account.velero-BSL.name
#        "subscriptionId" = "your-azure-subscription-id"
#      }
#      "credential" = {
#        "name" = "cloud-credentials"
#        "key"  = "cloud"
#      }
#      "default" = true
#    }
#  }
#}

#resourceGroupsample jvsdjbv