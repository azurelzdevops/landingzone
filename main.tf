provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags                = local.local_tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  address_space       = ["10.124.0.0/24"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_servers         = var.dns_servers
  tags                = local.local_tags
}

resource "azurerm_subnet" "subnet_fw" {
  name                 = local.subnet_fw_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [local.subnet_fw_cidr]
}

resource "azurerm_subnet" "subnet_gw" {
  name                 = local.subnet_gw_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [local.subnet_gw_cidr]
}

resource "azurerm_network_security_group" "nsg_fw" {
  name                = local.nsg_fw_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = var.nsg_fw_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}
/*
resource "azurerm_subnet_network_security_group_association" "nsg_fw_assoc" {
  subnet_id                 = azurerm_subnet.subnet_fw.id
  network_security_group_id = azurerm_network_security_group.nsg_fw.id
}
*/

resource "azurerm_route_table" "rt_fw" {
  name                = local.rt_fw_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "route" {
    for_each = var.route_fw_entries
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = try(route.value.next_hop_in_ip_address, null)
    }
  }
}

resource "azurerm_subnet_route_table_association" "rt_fw_assoc" {
  subnet_id      = azurerm_subnet.subnet_fw.id
  route_table_id = azurerm_route_table.rt_fw.id
}


resource "azurerm_route_table" "rt_gw" {
  name                = local.rt_gw_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "route" {
    for_each = var.route_gw_entries
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = try(route.value.next_hop_in_ip_address, null)
    }
  }
}

resource "azurerm_subnet_route_table_association" "rt_gw_assoc" {
  subnet_id      = azurerm_subnet.subnet_gw.id
  route_table_id = azurerm_route_table.rt_gw.id
}
