data "azurerm_subnet" "subnet-bastionhost" {
  name = "bastionhost-subnet"
  virtual_network_name = "axion-vnet"
   resource_group_name = "axion-rg"

}