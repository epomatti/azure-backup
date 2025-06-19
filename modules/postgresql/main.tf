resource "azurerm_private_dns_zone" "default" {
  name                = "${var.workload}.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "default" {
  name                  = "${var.workload}VnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.default.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.resource_group_name
}

resource "azurerm_postgresql_flexible_server" "default" {
  name                          = "psql-${var.workload}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = var.postgresql_version
  sku_name                      = var.postgresql_sku_name
  delegated_subnet_id           = var.postgresql_subnet_id
  private_dns_zone_id           = azurerm_private_dns_zone.default.id
  public_network_access_enabled = false
  administrator_login           = "psqladmin"
  administrator_password        = "H@Sh1CoR3!"
  zone                          = "1"
  storage_mb                    = 32768
  storage_tier                  = "P4"
  geo_redundant_backup_enabled  = var.geo_redundant_backup_enabled

  dynamic "high_availability" {
    for_each = var.high_availability_mode == "SameZone" || var.high_availability_mode == "ZoneRedundant" ? [1] : []
    content {
      mode = var.high_availability_mode
    }
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.default]
}
