output "backup_vault_principal_id" {
  value = azurerm_data_protection_backup_vault.default.identity[0].principal_id
}
