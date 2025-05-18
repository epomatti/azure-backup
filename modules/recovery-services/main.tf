resource "azurerm_recovery_services_vault" "default" {
  name                         = "rsv-${var.workload}"
  location                     = var.location
  resource_group_name          = var.resource_group_name
  sku                          = var.rsv_sku
  immutability                 = var.rsv_immutability
  storage_mode_type            = var.rsv_storage_mode_type
  cross_region_restore_enabled = var.rsv_cross_region_restore_enabled
  soft_delete_enabled          = var.rsv_soft_delete_enabled
}
