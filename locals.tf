locals {
  cloud        = "az"
  region       = "uks"
  env          = "p"
  sub_code     = "con"
  seq          = "01"
  seq_fw       = "01"
  seq_gw       = "02"

  prefix       = "${local.cloud}${local.region}${local.env}${local.sub_code}"
  rg_name      = "${local.prefix}rg${local.seq}"             # azukspconrg01
  vnet_name    = "${local.prefix}vnet${local.seq}"           # azukspconvnet01

  subnet_fw_name = "AzureFirewallSubnet"                     # Azure-required name
  subnet_gw_name = "GatewaySubnet"                           # Azure-required name

  subnet_fw_cidr = "10.124.0.0/26"
  subnet_gw_cidr = "10.124.0.128/27"

  nsg_fw_name = "${local.vnet_name}snet${local.seq_fw}nsg"   # azukspconvnet01snet01nsg
  rt_fw_name  = "${local.vnet_name}snet${local.seq_fw}rt"    # azukspconvnet01snet01rt
  rt_gw_name = "${local.vnet_name}snet${local.seq_gw}rt"  # azukspconvnet01snet02rt



    local_tags = {
    Environment  = "Production"
    Subscription = "Connectivity"
    Owner        = "Cloud Team"
    CostCenter   = "CONN1234"
  }

}
