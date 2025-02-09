output "public_ip_address" {
  value = azurerm_public_ip.main.ip_address
}

output "disk_id" {
  value = azurerm_linux_virtual_machine.main.os_disk[0].id
}
