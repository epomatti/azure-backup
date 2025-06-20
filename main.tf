terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

locals {
  allowed_public_cidrs = ["${var.public_ip_address_to_allow}/30"]
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${var.workload}-default"
  location = var.location
}

module "vnet" {
  source              = "./modules/virtual-network"
  workload            = var.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  allowed_public_ips  = [var.public_ip_address_to_allow]
}

module "virtual_machine" {
  source              = "./modules/virtual-machine"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  workload            = var.workload
  vm_public_key_path  = var.vm_public_key_path
  vm_admin_username   = var.vm_admin_username
  vm_size             = var.vm_size
  subnet_id           = module.vnet.default_subnet_id

  vm_image_publisher = var.vm_image_publisher
  vm_image_offer     = var.vm_image_offer
  vm_image_sku       = var.vm_image_sku
  vm_image_version   = var.vm_image_version
}

module "recover_services" {
  source                           = "./modules/recovery-services"
  location                         = azurerm_resource_group.default.location
  resource_group_name              = azurerm_resource_group.default.name
  workload                         = var.workload
  rsv_sku                          = var.rsv_sku
  rsv_immutability                 = var.rsv_immutability
  rsv_storage_mode_type            = var.rsv_storage_mode_type
  rsv_cross_region_restore_enabled = var.rsv_cross_region_restore_enabled
  rsv_soft_delete_enabled          = var.rsv_soft_delete_enabled
}

module "backup_vault_store" {
  source                              = "./modules/backup-vault"
  workload                            = var.workload
  resource_group_name                 = azurerm_resource_group.default.name
  location                            = azurerm_resource_group.default.location
  bvault_redundancy                   = var.bvault_redundancy
  bvault_immutability                 = var.bvault_immutability
  bvault_retention_duration_in_days   = var.bvault_retention_duration_in_days
  bvault_soft_delete                  = var.bvault_soft_delete
  bvault_cross_region_restore_enabled = var.bvault_cross_region_restore_enabled
  disk_id                             = module.virtual_machine.disk_id
}

module "storage" {
  source               = "./modules/storage-account"
  workload             = var.workload
  resource_group_name  = azurerm_resource_group.default.name
  location             = azurerm_resource_group.default.location
  allowed_public_cidrs = local.allowed_public_cidrs
}

module "postgresql" {
  source                       = "./modules/postgresql"
  workload                     = var.workload
  resource_group_name          = azurerm_resource_group.default.name
  location                     = azurerm_resource_group.default.location
  postgresql_version           = var.postgresql_version
  postgresql_sku_name          = var.postgresql_sku_name
  vnet_id                      = module.vnet.vnet_id
  postgresql_subnet_id         = module.vnet.postgresql_subnet_id
  high_availability_mode       = var.postgresql_high_availability_mode
  geo_redundant_backup_enabled = var.postgresql_geo_redundant_backup_enabled
}

# Required permissions for the Backup Vault to manage PostgreSQL backups
resource "azurerm_role_assignment" "backup_vault_rg_reader" {
  scope                = azurerm_resource_group.default.id
  role_definition_name = "Reader"
  principal_id         = module.backup_vault_store.backup_vault_principal_id
}

resource "azurerm_role_assignment" "backup_vault_postgresql_long_term_retention_backup_role" {
  scope                = module.postgresql.server_id
  role_definition_name = "PostgreSQL Flexible Server Long Term Retention Backup Role"
  principal_id         = module.backup_vault_store.backup_vault_principal_id
}
