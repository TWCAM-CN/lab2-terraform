module "networking"{
  source = "./modules/networking"
  ext_net_name = var.external_network_name
  net_name = var.network_name
  subnet_name = var.subnetwork_name
  router_name = var.router_name
}

module "secgroup"{
    source = "./modules/secgroup"
    secgroup_name = var.security_group_name
}

module "secgroup_rule_http"{
    source = "./modules/secgroup_rule"
}

module "server0" {
   source = "./modules/server"
   server_name = var.server0_name
   node_number = "0"
}

module "server1" {
   source = "./modules/server"
   server_name = var.server1_name
   node_number = "1"
}

module "server2" {
   source = "./modules/server"
   server_name = var.server2_name
   node_number = "2"
}

module "flotaing_ip" {
   source = "./modules/flotaing_ip"
   ext_net_name=var.external_network_name
}