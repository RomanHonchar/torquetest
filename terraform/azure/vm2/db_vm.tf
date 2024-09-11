provider "azurerm" {
  features {}
}

# Reference the existing resource group
data "azurerm_resource_group" "existing_rg" {
  name = "Cloudshell"
}

# Reference the existing virtual network
data "azurerm_virtual_network" "existing_vnet" {
  name                = "Cloudshell-vnet"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# Reference the existing subnet
data "azurerm_subnet" "existing_subnet" {
  name                 = "Cloudshell-server-net"
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
}

# Create a public IP address for the VM
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "db-vm-public-ip"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  allocation_method   = "Static"       # Change to Static for Standard SKU
  sku                 = "Standard"     # Standard SKU for the public IP
}


# Create a network interface for the VM
resource "azurerm_network_interface" "vm_nic" {
  name                = "db-vm-nic"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name

  ip_configuration {
    name                          = "db-vm-ip-config"
    subnet_id                     = data.azurerm_subnet.existing_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.vm_public_ip.id
  }
}

# Create a network security group to allow SSH access
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "db-vm-nsg"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "176.37.192.93/32"
    destination_address_prefix = "*"
  }
}

# Associate the NIC with the security group
resource "azurerm_network_interface_security_group_association" "vm_nic_sg" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

# Create the VM with Ubuntu 24.04
resource "azurerm_virtual_machine" "vm" {
  name                  = "db-ubuntu-vm"
  location              = data.azurerm_resource_group.existing_rg.location
  resource_group_name   = data.azurerm_resource_group.existing_rg.name
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  vm_size               = "Standard_B1s"  # Choose your VM size

  storage_os_disk {
    name              = "db-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"  # Ubuntu 24.04 image
    version   = "latest"
  }

  os_profile {
    computer_name  = "dbvm"
    admin_username = "csadmin"
    admin_password = "Cspassword-1"  # Use a stronger password or SSH keys for security
  }

  os_profile_linux_config {
    disable_password_authentication = false  # Set to true if using SSH keys
  }

  tags = {
    environment = "Test"
  }
}

output "public_ip_address" {
  value = azurerm_public_ip.vm_public_ip.ip_address
}
