variable "workload" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

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
  type = bool
}

variable "disk_id" {
  type = string
}
