output "vm_name" {
    value = azurerm_linux_virtual_machine.vm.name
    description = "value of the virtual machine name"
  }
output "public_ip" {
    value = azurerm_public_ip.public_ip.ip_address
    description = "value of the public IP address of the virtual machine"
  }
