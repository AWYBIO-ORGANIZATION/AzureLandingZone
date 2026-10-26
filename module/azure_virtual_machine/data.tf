data "azurerm_subnet" "subnets" {
  for_each = var.virtual_machine
  name = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
   resource_group_name = each.value.rg_name

}



