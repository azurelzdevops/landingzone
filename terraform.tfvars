subscription_id = "1f912abd-35c9-418f-adc0-30b7a902b1f7"

dns_servers = ["10.124.0.4", "10.124.0.5"]

nsg_fw_rules = [
  {
    name                       = "azukspconsnet01rul01in"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

route_fw_entries = [
  {
    name                   = "default-to-internet"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "Internet"
  }
]

route_gw_entries = []