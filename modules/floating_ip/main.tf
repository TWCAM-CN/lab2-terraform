resource "openstack_networking_floatingip_v2" "proyecto11_floating_ip" {
  pool = var.pool
}

resource "openstack_compute_floatingip_associate_v2" "associate_floating_ip" {
  floating_ip = openstack_networking_floatingip_v2.floating_ip.address
  instance_id = var.instance_id
}
