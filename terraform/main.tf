# 1. Definición de Variables (Para no dejar contraseñas en el código)
variable "vm_admin_password" {
  description = "Contraseña de administrador para la VM"
  type        = string
  sensitive   = true
}

# 2. Grupo de Recursos
resource "azurerm_resource_group" "rg" {
  name     = "rg-tfg-micky-wordpress"
  location = "francecentral" 
}

# 3. Red Virtual (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-tfg-segura"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 4. Subred
resource "azurerm_subnet" "subnet" {
  name                 = "snet-wordpress-prod"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [ azurerm_virtual_network.vnet ]
}

# 5. Grupo de Seguridad (NSG)
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-wordpress-prod"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# 6. Asociación NSG
resource "azurerm_subnet_network_security_group_association" "snet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
  depends_on = [ azurerm_subnet.subnet, azurerm_network_security_group.nsg ]
}

# 7. IP Pública
resource "azurerm_public_ip" "pip" {
  name                = "pip-wordpress-prod"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# 8. Interfaz de Red (NIC)
resource "azurerm_network_interface" "nic" {
  name                = "nic-wordpress-prod"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig-wordpress"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

# 9. Máquina Virtual
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-wordpress-prod"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2d_v4"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  # Usamos la variable en lugar de escribir la contraseña
  admin_password                  = var.vm_admin_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# 10. Output de la IP
output "public_ip_address" {
  value = azurerm_public_ip.pip.ip_address
}
