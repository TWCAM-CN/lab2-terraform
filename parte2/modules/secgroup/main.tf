module "secgroup_rules" {
  source = "./secgroup_rules"
}

resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = var.secgroup_name
  description = var.secgroup_description
}

module.secgroup_rules