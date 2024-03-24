module "networking"{
  source = "./modules/networking"
  ext_net_name = var.external_network_name
  net_name = var.network_name
  subnet_name = var.subnetwork_name
  router_name = var.router_name
}

module "secgroup"{
    source = "./modules/secgroup"
    secgroup_name = var.secgroup_name
}

module "secgroup_rule" {
    source             = "./modules/secgroup_rule"
    security_group_id  = openstack_networking_secgroup_v2.proyecto11_secgroup.id
}

module "server0" {
   source = "./modules/server"
   flavor_id = var.flavor_id
   server_name = var.server0_name
   node_number = "0"
   secgroup_name = module.secgroup.secgroup_id
}

module "server1" {
   source = "./modules/server"
   server_name = var.server1_name
   node_number = "1"
   secgroup_name = module.secgroup.secgroup_id
}

module "server2" {
   source = "./modules/server"
   server_name = var.server2_name
   node_number = "2"
   secgroup_name = module.secgroup.secgroup_id
}

module "floating_ip" {
   source = "./modules/floating_ip"
   pool = var.pool_name
   instance_id = module.networking.instance_id
}
