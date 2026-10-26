resource "azurerm_network_interface" "axion_nic" {
  for_each = var.virtual_machine
  name = each.value.nic_name
  location = each.value.location
  resource_group_name = each.value.rg_name
  
  ip_configuration {
    name = "nic-ip"
    subnet_id = data.azurerm_subnet.subnets[each.key].id
   
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "nsg" {
    for_each = var.virtual_machine
  name                = each.value.nsg_name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  dynamic "security_rule" {
    for_each = local.vm_rules[each.value.nsg_name]
    iterator = rule
  

  content {
    name                       = rule.key
    priority                   = rule.value.priority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    destination_port_range     = rule.value.port
  }
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  for_each = var.virtual_machine

  network_interface_id      = azurerm_network_interface.axion_nic[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

resource "azurerm_linux_virtual_machine" "axion_vms" {
  for_each = var.virtual_machine

  name = each.value.vm_name
  location = each.value.location
  resource_group_name = each.value.rg_name
  size = each.value.vm_size
  network_interface_ids = [azurerm_network_interface.axion_nic[each.key].id]
  
  disable_password_authentication = false 
  admin_username = each.value.username
  admin_password = each.value.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
  publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
}
}

