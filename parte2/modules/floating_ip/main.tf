resource "openstack_networking_floatingip_v2" "fip" {
  pool = var.pool
}

resource "openstack_compute_floatingip_associate_v2" "associate_floating_ip" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  instance_id = var.instance_id
}
