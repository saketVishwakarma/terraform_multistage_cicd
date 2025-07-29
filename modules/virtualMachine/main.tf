resource "azurerm_public_ip" "public_ip" {
    name                = "${var.vm_name}-ip"
    location            = var.location
    resource_group_name = var.resource_group_name
    allocation_method   = "Static"
    sku                 = "Standard"
  }
resource "azurerm_network_interface" "nic" {
     name                = "${var.vm_name}-nic"
     location            = var.location
     resource_group_name = var.resource_group_name
    ip_configuration {
       name                          = "internal"
       subnet_id                     = var.subnet_id
       private_ip_address_allocation = "Dynamic"
       public_ip_address_id          = azurerm_public_ip.public_ip.id
     }
}
resource "azurerm_linux_virtual_machine" "vm" {
    name                  = var.vm_name
    location              = var.location
    resource_group_name  = var.resource_group_name
    size                  = var.vm_size
    admin_username        = var.admin_username
    network_interface_ids = [azurerm_network_interface.nic.id]
    disable_password_authentication = true
    os_disk {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
      name                 = "${var.vm_name}-osdisk"
    }
    source_image_reference {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "20_04-lts"
      version   = "latest"
    }
    admin_ssh_key {
  username   = var.admin_username
  public_key = var.public_key
}
    provisioner "remote-exec" {
      inline = [
        "sudo apt-get update -y",
        "sudo apt-get install -y nginx"
      ]
      connection {
      type        = "ssh"
      user        = var.admin_username
      host        = azurerm_public_ip.public_ip.ip_address
      private_key = var.private_key
      timeout     = "5m"
    }
    }
lifecycle {
      ignore_changes = [admin_ssh_key]
    }
  }
