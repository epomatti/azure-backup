variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "workload" {
  type = string
}

variable "allowed_public_cidrs" {
  type = list(string)
}
