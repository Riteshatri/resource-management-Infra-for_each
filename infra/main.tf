module "rg_module" {
  for_each = var.resource_groups

  source   = "../modules/resourceGroup/azurerm_resource_group"
  rg_name  = each.value.name
  location = each.value.location
}


module "vnet_module" {
  source     = "../modules/networking/azurerm_virtual_network"
  depends_on = [module.rg_module]
  vnets      = var.vnets
}

module "nsg_module" {
  source     = "../modules/networking/azurerm_nsg"
  depends_on = [module.rg_module]
  nsg        = var.nsg
}


module "nic_module" {
  source     = "../modules/networking/azurerm_nic"
  depends_on = [module.rg_module, module.vnet_module, module.nsg_module, module.pip_module]
  nics       = var.nics
  pip_ids    = module.pip_module.pip_ids

}

module "pip_module" {
  source     = "../modules/networking/azurerm_pip"
  depends_on = [module.rg_module]
  pips       = var.pips
}

# module "bastion_module" {
#   source     = "../modules/networking/azurerm_bastion"
#   depends_on = [module.rg_module, module.vnet_module, module.pip_module]
#   bastion    = var.bastion
# }

module "nic_nsg_assoc_module" {
  source      = "../modules/networking/azurerm_nic_nsg_assoc"
  depends_on  = [module.nic_module, module.nsg_module]
  nic_nsg_ids = var.nic_nsg_ids
}

module "vm_module" {
  source = "../modules/virtual_machine"

  depends_on = [module.rg_module, module.nic_module]
  vms        = var.vms
}


# module "sql_server" {
#   depends_on  = [module.rg_module]
#   source      = "../modules/database/azurerm_mssql_server"
#   sql_servers = var.sql_servers
# }


# locals {
#   firewall_rules = {
#     "backend-AllowIP" = {
#       server_id        = "ritserver"
#       name             = "backendpip"
#       start_ip_address = module.pip_module.pip_ip_addresses["backendpip"]
#       end_ip_address   = module.pip_module.pip_ip_addresses["backendpip"]
#     }

#     "client-AllowIP" = {
#       server_id        = "ritserver"
#       name             = "clientaddress"
#       start_ip_address = "49.43.131.38"
#       end_ip_address   = "49.43.131.38"
#     }
#   }
# }

# module "sql_module" {
#   source          = "../modules/sql"
#   firewall_rules  = local.firewall_rules
# }


# module "firewall_rule" {
#   depends_on      = [module.sql_server]
#   source          = "../modules/database/azurerm_mssql_firewall_rule"
#   firewall_rules  = var.firewall_rules
#   sql_servers     = var.sql_servers
#   sql_servers_ids = module.sql_server.sql_servers_ids
# }

# module "database" {
#   depends_on    = [module.sql_server, module.firewall_rule]
#   source        = "../modules/database/azurerm_mssql_database"
#   sql_databases = var.sql_databases
# }



module "sql_server" {
  depends_on  = [module.rg_module]
  source      = "../modules/database/azurerm_mssql_server"
  sql_servers = var.sql_servers
}

locals {
  firewall_rules = {
    "backend-AllowIP" = {
      server_id        = "ritserver"
      name             = "backendpip"
      start_ip_address = module.pip_module.pip_ip_addresses["backendpip"]
      end_ip_address   = module.pip_module.pip_ip_addresses["backendpip"]
    }

    "client-AllowIP" = {
      server_id        = "ritserver"
      name             = "clientaddress"
      start_ip_address = "49.43.131.38"
      end_ip_address   = "49.43.131.38"
    }
  }
}

module "firewall_rule" {
  depends_on      = [module.sql_server, module.pip_module]
  source          = "../modules/database/azurerm_mssql_firewall_rule"
  firewall_rules  = local.firewall_rules
  sql_servers     = var.sql_servers
  sql_servers_ids = module.sql_server.sql_servers_ids
}

module "database" {
  depends_on    = [module.sql_server, module.firewall_rule]
  source        = "../modules/database/azurerm_mssql_database"
  sql_databases = var.sql_databases
}