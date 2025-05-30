data "azurerm_client_config" "current" {}

resource "azurerm_storage_account" "default" {
  name                       = "st${var.workload}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  account_kind               = "StorageV2"
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"
  access_tier                = "Hot"

  # Networking
  public_network_access_enabled = true

  blob_properties {
    versioning_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }

  # Internet / Microsoft routing
  network_rules {
    default_action = "Deny"
    ip_rules       = var.allowed_public_cidrs
    bypass         = ["AzureServices"]
  }
}

### Containers ###
resource "azurerm_storage_container" "default" {
  name                  = "default"
  storage_account_id    = azurerm_storage_account.default.id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "data_contributor" {
  scope                = azurerm_storage_account.default.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}
