// main.tf
resource "openstack_networking_secgroup_v2" "proyecto11_secgroup" {
    name        = var.secgroup_name
    description = var.security_group_description
}

module "secgroup_rules" {
    source             = "./modules/secgroup_rules"
    security_group_id  = openstack_networking_secgroup_v2.proyecto11_secgroup.id
}