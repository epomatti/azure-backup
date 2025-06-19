variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "vnet_id" {
  type = string
}

variable "postgresql_subnet_id" {
  type = string
}

variable "postgresql_version" {
  type = string
}

variable "postgresql_sku_name" {
  type = string
}

variable "high_availability_mode" {
  type = string
}
variable "geo_redundant_backup_enabled" {
  type = bool
}
