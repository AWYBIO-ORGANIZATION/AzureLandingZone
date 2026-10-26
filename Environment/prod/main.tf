module "resource_group" {
  source = "../../module/azure_resource_group"
  rg_we = {
    rg1={
        name = "axion-rg-we"
    }
  }
}