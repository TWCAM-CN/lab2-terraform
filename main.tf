# Definición del provider
provider "openstack" {
  # Configuración específica de tu proveedor OpenStack
}

# Módulo de Networking
module "networking" {
  source       = "./modules/networking"
  ext_net_name = var.external_network_name
  net_name     = var.network_name
  subnet_name  = var.subnetwork_name
  router_name  = var.router_name
  cidr         = "10.0.0.0/24"
}

# Módulo de Security Group
module "secgroup" {
  source        = "./modules/secgroup"
  secgroup_name = var.secgroup_name
  secgroup_description = var.secgroup_description
}

# Módulo de Security Group Rule
module "secgroup_rule" {
  source            = "./modules/secgroup_rule"
  security_group_id = module.secgroup.secgroup_id
  from_port_http    = 80
  to_port_http      = 80
  protocol_http     = "tcp"
  direction         = "ingress"
  ethertype         = "IPv4"
}

# Módulo de Server para server0
module "server0" {
  source       = "./modules/server"
  image_id     = var.image_id
  flavor_id    = var.flavor_id
  network_id   = module.networking.network_id
  secgroup_id  = module.secgroup.secgroup_id
  key_name     = var.key_name
  server_name  = var.server0_name
  node_number  = "0"
  depends_on = [module.networking]
}

# Módulo de Server para server1
module "server1" {
  source       = "./modules/server"
  image_id     = var.image_id
  flavor_id    = var.flavor_id
  network_id   = module.networking.network_id
  secgroup_id  = module.secgroup.secgroup_id
  key_name     = var.key_name
  server_name  = var.server1_name
  node_number  = "1"
  depends_on = [module.networking]
}

# Módulo de Server para server2
module "server2" {
  source       = "./modules/server"
  image_id     = var.image_id
  flavor_id    = var.flavor_id
  network_id   = module.networking.network_id
  secgroup_id  = module.secgroup.secgroup_id
  key_name     = var.key_name
  server_name  = var.server2_name
  node_number  = "2"
  depends_on = [module.networking]
}

module "floating_ip" {
  source      = "./modules/floating_ip"
  pool        = var.pool
}
