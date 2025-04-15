resource "azurerm_virtual_network" "minecraft_vnet" {
  name                = "minecraft-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.minecraft_rg.name
}

resource "azurerm_subnet" "minecraft_subnet" {
  name                 = "minecraft-subnet"
  resource_group_name  = azurerm_resource_group.minecraft_rg.name
  virtual_network_name = azurerm_virtual_network.minecraft_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "minecraft_nsg" {
  name                = "minecraft-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.minecraft_rg.name

  security_rule {
    name                       = "AllowMinecraftPort"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "25565"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "minecraft_nic" {
  name                = "minecraft-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.minecraft_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.minecraft_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.minecraft_ip.id
  }
}

resource "azurerm_public_ip" "minecraft_ip" {
  name                = "minecraftPublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.minecraft_rg.name
  allocation_method   = "Static"     # <--- ¡IP fija!
  sku                 = "Basic"
}

resource "azurerm_network_interface_security_group_association" "minecraft_nic_nsg" {
  network_interface_id      = azurerm_network_interface.minecraft_nic.id
  network_security_group_id = azurerm_network_security_group.minecraft_nsg.id
}

output "minecraft_public_ip" {
  value = azurerm_public_ip.minecraft_ip.ip_address
}