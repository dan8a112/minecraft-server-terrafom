resource "azurerm_linux_virtual_machine" "minecraft_vm" {
  name                = "minecraft-vm"
  resource_group_name = azurerm_resource_group.minecraft_rg.name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  custom_data         = filebase64("${path.module}/minecraft-init.sh")
  network_interface_ids = [
    azurerm_network_interface.minecraft_nic.id,
  ]
  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${path.module}/${var.ssh_public_key}")
  }
  os_disk {
    name                 = "minecraft_os_disk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb       = 30
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  computer_name = "minecraft"
  disable_password_authentication = true
  provision_vm_agent = true
}