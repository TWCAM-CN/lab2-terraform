resource "openstack_networking_secgroup_rule_v2" "http_rule" {
  direction         = var.direction
  ethertype         = var.ethertype
  protocol          = var.protocol_http
  port_range_min    = var.from_port_http
  port_range_max    = var.to_port_http
  security_group_id = var.security_group_id
}
