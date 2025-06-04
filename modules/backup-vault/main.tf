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

resource "azurerm_data_protection_backup_policy_blob_storage" "default" {
  name                                   = "default-backup-policy"
  vault_id                               = azurerm_data_protection_backup_vault.default.id
  operational_default_retention_duration = "P30D"
}

resource "azurerm_data_protection_backup_policy_blob_storage" "short_term" {
  name                                   = "short-term-backup-policy"
  vault_id                               = azurerm_data_protection_backup_vault.default.id
  operational_default_retention_duration = "P7D"
}

# resource "azurerm_data_protection_backup_policy_disk" "default" {
#   name     = "bkpol-${var.workload}"
#   vault_id = azurerm_data_protection_backup_vault.default.id

#   backup_repeating_time_intervals = ["R/2021-05-19T06:33:16+00:00/PT4H"]
#   default_retention_duration      = "P7D"
#   time_zone                       = "W. Europe Standard Time"

#   retention_rule {
#     name     = "Daily"
#     duration = "P7D"
#     priority = 25
#     criteria {
#       absolute_criteria = "FirstOfDay"
#     }
#   }

#   retention_rule {
#     name     = "Weekly"
#     duration = "P7D"
#     priority = 20
#     criteria {
#       absolute_criteria = "FirstOfWeek"
#     }
#   }
# }

# resource "azurerm_data_protection_backup_instance_disk" "default" {
#   name                         = "backup-instance"
#   location                     = var.location
#   vault_id                     = azurerm_data_protection_backup_vault.default.id
#   disk_id                      = var.disk_id
#   snapshot_resource_group_name = var.resource_group_name
#   backup_policy_id             = azurerm_data_protection_backup_policy_disk.default.id
# }
