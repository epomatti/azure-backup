resource "azurerm_data_protection_backup_vault" "default" {
  name                         = "bvault-${var.workload}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  datastore_type               = "VaultStore"
  redundancy                   = var.bvault_redundancy
  immutability                 = var.bvault_immutability
  retention_duration_in_days   = var.bvault_retention_duration_in_days
  soft_delete                  = var.bvault_soft_delete
  cross_region_restore_enabled = var.bvault_cross_region_restore_enabled

  identity {
    type = "SystemAssigned"
  }
}
