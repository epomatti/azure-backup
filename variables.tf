### General ###
variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "public_ip_address_to_allow" {
  type = string
}

### Virtual Machine ###
variable "vm_admin_username" {
  type = string
}

variable "vm_public_key_path" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "vm_image_publisher" {
  type = string
}

variable "vm_image_offer" {
  type = string
}

variable "vm_image_sku" {
  type = string
}

variable "vm_image_version" {
  type = string
}

### Backup Vault ###
variable "bvault_redundancy" {
  type = string
}

variable "bvault_retention_duration_in_days" {
  type = number
}

variable "bvault_immutability" {
  type = string
}

variable "bvault_soft_delete" {
  type = string
}

variable "bvault_cross_region_restore_enabled" {
  type = string
}

### Recovery Services Vault ###
variable "rsv_sku" {
  type = string
}

variable "rsv_immutability" {
  type = string
}

variable "rsv_storage_mode_type" {
  type = string
}

variable "rsv_cross_region_restore_enabled" {
  type = string
}

variable "rsv_soft_delete_enabled" {
  type = string
}

#### PostgreSQL ###
variable "postgresql_version" {
  type = string
}

variable "postgresql_sku_name" {
  type = string
}
