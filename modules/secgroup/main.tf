// main.tf
resource "openstack_networking_secgroup_v2" "proyecto11_secgroup" {
    name        = var.secgroup_name
    description = var.secgroup_description
}