resource "azurerm_public_ip" "main" {
  name                = "pip-${var.workload}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                = "nic-${var.workload}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig001"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                  = "vm-${var.workload}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.vm_admin_username
  network_interface_ids = [azurerm_network_interface.main.id]

  secure_boot_enabled = true
  vtpm_enabled        = true

  bypass_platform_safety_checks_on_user_schedule_enabled = true
  patch_mode                                             = "AutomaticByPlatform"

  custom_data = filebase64("${path.module}/custom_data/ubuntu.sh")

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = file(var.vm_public_key_path)
  }

  os_disk {
    name                 = "osdisk-${var.workload}"
    caching              = "ReadOnly"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }

  lifecycle {
    ignore_changes = [custom_data]
  }
}

resource "azurerm_managed_disk" "data_disk" {
  name                 = "disk-${var.workload}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "20"
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk" {
  managed_disk_id    = azurerm_managed_disk.data_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.main.id
  lun                = "10"
  caching            = "ReadOnly"
}
