// modules/secgroup_rules/main.tf
resource "openstack_networking_secgroup_rule_v2" "http_rule" {
    direction         = var.direction
    ethertype         = var.ethertype
    protocol          = var.protocol_http
    port_range_min    = var.from_port_http
    port_range_max    = var.to_port_http
    security_group_id = module.secgroup.secgroup_id
}

resource "openstack_networking_secgroup_rule_v2" "icmp_rule" {
    direction         = var.direction
    ethertype         = var.ethertype
    protocol          = var.protocol_icmp
    security_group_id =  module.secgroup.secgroup_id
}