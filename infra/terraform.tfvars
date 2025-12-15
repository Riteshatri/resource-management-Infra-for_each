resource_groups = {
  rg1 = {
    name     = "PutRgNameHere"
    location = "North Europe"
  }
}

######

vnets = {
  vnetOne = {
    vnet_name     = "vnetNameHere"
    location      = "North Europe"
    rg_name       = "PutRgNameHere"
    address_space = ["10.0.0.0/23"] # 512 addresses
    subnets = {
      subnet1 = {
        subnet_name             = "frontendsubnet"
        subnet_address_prefixes = ["10.0.0.0/24"] # 256 addresses
      }
    }
  }
  backendvnet = {
    vnet_name     = "backendendvnet"
    location      = "North Europe"
    rg_name       = "PutRgNameHere"
    address_space = ["10.0.0.0/23"] # 512 addresses
    subnets = {
      subnet2 = {
        subnet_name             = "backendsubnet"
        subnet_address_prefixes = ["10.0.1.0/25"] # 128 addresses
      }
    }
  }
}
#####

nsg = {
  frontend_nsg = {
    nsg_name = "frontendnsg"
    location = "North Europe"
    rg_name  = "PutRgNameHere"

    security_rules = {
      allow_http = {
        security_rule_name         = "allow-http"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
      allow_ssh = {
        security_rule_name         = "allow-ssh"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    }
  }
  backendend_nsg = {
    nsg_name = "backendnsg"
    location = "North Europe"
    rg_name  = "PutRgNameHere"

    security_rules = {
      allow_http = {
        security_rule_name         = "allow-8000"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8000"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
      allow_ssh = {
        security_rule_name         = "allow-ssh"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    }
  }
}

#####

nics = {
  frontend_nic = {
    nic_name    = "frontendnic"
    rg_name     = "PutRgNameHere"
    location    = "North Europe"
    vnet_name   = "vnetNameHere"
    subnet_name = "frontendsubnet"

    ip_configurations = {
      ipconfig1 = {
        ip_config_name        = "frontend-internal"
        private_ip_allocation = "Dynamic"
        public_ip_name        = "frontendpip"
      }
    }
  }

  backend_nic = {
    nic_name    = "backendnic"
    rg_name     = "PutRgNameHere"
    location    = "North Europe"
    vnet_name   = "backendendvnet"
    subnet_name = "backendsubnet"

    ip_configurations = {
      ipconfig2 = {
        ip_config_name        = "backend-internal"
        private_ip_allocation = "Dynamic"
        primary               = true
        public_ip_name        = "backendpip"
      }
    }
  }
}

#####

pips = {
  frontend_pip = {
    pip_name = "frontendpip"
    location = "North Europe"
    rg_name  = "PutRgNameHere"
  }
  backend_pip = {
    pip_name = "backendpip"
    location = "North Europe"
    rg_name  = "PutRgNameHere"
  }
}

#####

nic_nsg_ids = {
  nic_nsg_1 = {
    nic_name = "frontendnic"
    nsg_name = "frontendnsg"
    rg_name  = "PutRgNameHere"
  }
  nic_nsg_2 = {
    nic_name = "backendnic"
    nsg_name = "backendnsg"
    rg_name  = "PutRgNameHere"
  }
}

#####

vms = {
  frontend = {
    vm_name                      = "frontendvm"
    rg_name                      = "PutRgNameHere"
    location                     = "North Europe"
    vm_size                      = "Standard_D2s_v3"
    admin_username               = "ritesh"
    admin_password               = "Ritesh@12345"
    nic_name                     = "frontendnic"
    os_disk_caching              = "ReadWrite"
    os_disk_storage_account_type = "Premium_LRS"
    vm_publisher                 = "Canonical"
    vm_offer                     = "ubuntu-24_04-lts"
    vm_sku                       = "server"
    vm_version                   = "latest"
    custom_data                  = <<-EOT
      #!/bin/bash
      sudo apt update
      sudo apt upgrade -y
      sudo apt install -y nginx
      sudo rm -rf /var/www/html/*
      systemctl enable nginx
      systemctl start nginx
    EOT
  }
  backend = {
    vm_name                      = "backendvm"
    rg_name                      = "PutRgNameHere"
    location                     = "North Europe"
    vm_size                      = "Standard_D2s_v3"
    admin_username               = "ritesh"
    admin_password               = "Ritesh@12345"
    nic_name                     = "backendnic"
    os_disk_caching              = "ReadWrite"
    os_disk_storage_account_type = "Premium_LRS"
    vm_publisher                 = "Canonical"
    vm_offer                     = "ubuntu-24_04-lts"
    vm_sku                       = "server"
    vm_version                   = "latest"
    custom_data                  = <<-EOT
      #!/bin/bash
      apt update -y
      apt upgrade -y
    EOT
  }
}

#####

sql_servers = {
  ritserver = {
    sqlservername                 = "ritserver"
    rg_name                       = "PutRgNameHere"
    location                      = "North Europe"
    version                       = "12.0"
    server_login_username         = "ritserver"
    server_login_password         = "Ritesh@12345"
    public_network_access_enabled = true
  }
}

######

firewall_rules = {
  # "server1-AllowIP-client" = {
  #   server_id        = "ritserver"
  #   name             = "clientaddress"
  #   start_ip_address = "49.43.131.38"
  #   end_ip_address   = "49.43.131.38"
  # }
  # "backend-AllowIP" = {
  #   server_id        = "ritserver"
  #   name             = "backendpip"
  #   start_ip_address = module.pip_module.pip_ip_addresses["backendpip"]
  #   end_ip_address   = module.pip_module.pip_ip_addresses["backendpip"]
  # }
}

sql_databases = {
  ritdb = {
    name           = "ritserver"
    server_name    = "ritserver"
    resource_group = "PutRgNameHere"
    sku_name       = "S1"
    max_size_gb    = 20
    zone_redundant = false
  }
  # db2 = {
  #   name           = "analyticsdb"
  #   server_name    = "ritsqlserver112"
  #   resource_group = "PutRgNameHere"
  #   sku_name       = "S1"
  #   max_size_gb    = 20
  #   zone_redundant = false
  # }
}
