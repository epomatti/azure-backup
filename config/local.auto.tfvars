### General ###
location                   = "eastus2"
workload                   = "litware"
public_ip_address_to_allow = "100.100.100.100"
subscription_id            = "00000000-0000-0000-0000-000000000000"

### Virtual Machine ###
vm_admin_username  = "azureuser"
vm_public_key_path = ".keys/tmp_rsa.pub"
vm_size            = "Standard_B2ls_v2"
vm_image_publisher = "canonical"
vm_image_offer     = "ubuntu-24_04-lts"
vm_image_sku       = "server"
vm_image_version   = "latest"

### Backup Vaults - VaultStore ###
bvault_redundancy                   = "LocallyRedundant"
bvault_retention_duration_in_days   = 14 # Required when soft delete is "On"
bvault_immutability                 = "Disabled"
bvault_soft_delete                  = "Off"
bvault_cross_region_restore_enabled = null # Onfy for "GeoRedundant" redundancy

### Recovery Services Vault ###
rsv_sku                          = "Standard"
rsv_immutability                 = "Disabled"
rsv_storage_mode_type            = "LocallyRedundant"
rsv_cross_region_restore_enabled = false
rsv_soft_delete_enabled          = false

### PostgreSQL ###
postgresql_version  = "16"
postgresql_sku_name = "GP_Standard_D2ds_v4" # Standard required for on-demand backups: GP_Standard_D2ds_v4
