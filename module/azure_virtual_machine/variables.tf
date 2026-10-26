variable "virtual_machine" {
  type = map(any)
}

locals {
  vm_rules = {
    frontend-nsg = {
      HTTP = {
        port     = 80
        priority = 100
      }
      SSH = {
        port     = 22
        priority = 110
      }
    }

    backend-nsg = {
      SSH = {
        port     = 22
        priority = 110
      }
      TCP = {
        port = 8000
        priority = 120
      }
    }

    database-nsg = {
      SSH = {
        port     = 22
        priority = 110
      }

      PostgreSQL = {
        port     = 5432
        priority = 120
      }
    }
  }
}
