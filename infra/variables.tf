variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
  }))
}

######
######
######

variable "vnets" {
  type = map(object({
    vnet_name     = string
    location      = string
    rg_name       = string
    address_space = list(string)
    subnets = optional(map(object({
      subnet_name             = string
      subnet_address_prefixes = list(string)
    })))
  }))
}


#####
#####
#####

variable "nsg" {
  description = "List of security rules"
  type = map(object({
    nsg_name = string
    location = string
    rg_name  = string
    security_rules = optional(map(object({
      security_rule_name         = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })))
  }))
}



#####
#####
#####
variable "nics" {
  description = "Map of NIC configurations"
  type = map(object({
    nic_name    = string
    rg_name     = string
    vnet_name   = string
    subnet_name = string
    location    = string

    ip_configurations = optional(map(object({
      ip_config_name        = string
      private_ip_allocation = string
      private_ip_address    = optional(string)
      public_ip_name        = optional(string)
      primary               = optional(bool, false)
    })))
  }))
}

#####
#####
#####
variable "pips" {
  description = "A map of public IP configurations"
  type = map(object({
    pip_name = string
    location = string
    rg_name  = string
  }))
}


#####
#####
#####

# variable "bastion" {
#   type = map(object({
#     bastion_name = string
#     location     = string
#     rg_name      = string
#     vnet_name    = string
#     subnet_name  = string
#     pip_name     = string

#     ip_configuration = object({
#       name = string
#     })
#   }))
# }

#####
#####
#####

variable "nic_nsg_ids" {
  description = "A map of objects containing NIC and NSG names along with their resource group names."
  type = map(object({
    nic_name = string
    nsg_name = string
    rg_name  = string
  }))
}

#####
#####
#####
variable "vms" {
  description = "A map of virtual machine configurations"
  type = map(object({
    vm_name                      = string
    rg_name                      = string
    location                     = string
    vm_size                      = string
    admin_username               = string
    admin_password               = string
    nic_name                     = string
    os_disk_caching              = string
    os_disk_storage_account_type = string
    vm_publisher                 = string
    vm_offer                     = string
    vm_sku                       = string
    vm_version                   = string
    custom_data                  = optional(string)
  }))
}


# Variable for SQL Servers
variable "sql_servers" {
  description = "Map of SQL Server configurations"
  type = map(object({
    sqlservername                 = string
    rg_name                       = string
    location                      = string
    version                       = string
    server_login_username         = string
    server_login_password         = string
    public_network_access_enabled = optional(bool, false)
  }))
}





# Variable for flattened firewall rules
variable "firewall_rules" {
  description = "Flattened firewall rules with server_id reference"
  type = map(object({
    server_id        = string
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
}


variable "sql_databases" {
  description = "Map of SQL Databases with info about which server they belong to"
  type = map(object({
    name           = string
    server_name    = string
    resource_group = string
    sku_name       = string
    collation      = optional(string, "SQL_Latin1_General_CP1_CI_AS")
    max_size_gb    = optional(number, 5)
    zone_redundant = optional(bool, false)
  }))
}
