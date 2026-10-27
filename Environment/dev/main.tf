module "resource_group" {
  source = "../../module/azure_resource_group"
  rg_we = {
    rg1={
    name = "axion-rg"
    location = "central india"
  }

  rg1={
    name = "axion-rg"
    location = "central india"
  }
 
  

  }
}


module "virtual_network" {
  source = "../../module/azure_virtual_network"
  depends_on = [ module.resource_group ]
  vnet-we = {
  vnet-1={
  name = "axion-vnet"
  location = "central india"
  resource_group_name = "axion-rg"
  address_space = ["10.0.0.0/16"]
  }
}
}

module "subnet" {
  source = "../../module/azure_subnet"
  depends_on = [ module.virtual_network ]
  subnet-we = {
  subnet-1 ={
     subnet_name = "frontend-subnet"
  resource_group_name = "axion-rg"
  virtual_network_name = "axion-vnet"
  address_prefixes = [ "10.0.2.0/24" ]
  }

  subnet-2 = {
  subnet_name = "backend-subnet"
  resource_group_name = "axion-rg"
  virtual_network_name = "axion-vnet"
  address_prefixes = [ "10.0.1.0/24" ]
  }

  subnet-3 = {
    subnet_name = "database-subnet"
  resource_group_name = "axion-rg"
  virtual_network_name = "axion-vnet"
  address_prefixes = [ "10.0.3.0/24" ]
  }

  subnet-4 ={
    subnet_name = "AzureBastionSubnet"
  resource_group_name = "axion-rg"
  virtual_network_name = "axion-vnet"
  address_prefixes = [ "10.0.4.0/24" ]
  }
}
}



module "virtual_machine" {
  source = "../../module/azure_virtual_machine"
  depends_on = [ module.subnet, module.azurerm_public_ip ]
  virtual_machine= {
    vm-1={
    nic_name = "axn-preprod-ci-vm-fe-01"
    location = "central india"
    rg_name = "axion-rg"
    virtual_network_name = "axion-vnet"
    subnet_name = "frontend-subnet"
    vm_name = "frontend-vm"
    vm_size = "Standard_DC1ds_v3"
    username = "adminone"
    admin_password = "Pcafe123"
    nsg_name = "frontend-nsg"
  }
  
    vm-2={
    nic_name = "axn-preprod-ci-vm-be-01"
    location = "central india"
    rg_name = "axion-rg"
    virtual_network_name = "axion-vnet"
    subnet_name = "backend-subnet"
    vm_name = "backend-vm"
    vm_size = "Standard_DC1ds_v3"
    username = "admintwo"
    admin_password = "Pcafe123"
    nsg_name = "backend-nsg"

  }

      vm-3={
    nic_name = "axn-preprod-ci-vm-db-01"
    location = "central india"
    rg_name = "axion-rg"
    virtual_network_name = "axion-vnet"
    subnet_name = "database-subnet"
    vm_name = "database-vm"
    vm_size = "Standard_DC1ds_v3"
    username = "adminthree"
    admin_password = "Pcafe123"
    nsg_name = "database-nsg"
  }
 
}

}

module "azurerm_public_ip" {
  source = "../../module/azure_public_ip"
  depends_on = [ module.resource_group ]
  pip = {
    pip-1 ={
  name                = "frontend-pip"
  resource_group_name = "axion-rg"
  location            = "central india"

    }
    
    pip-3 ={
  name                = "database-pip"
  resource_group_name = "axion-rg"
  location            = "central india"
  
    }     
}
  
}





