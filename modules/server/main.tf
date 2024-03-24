resource "openstack_compute_instance_v2" "proyecto11_server" {
  image_id        = var.image_id
  flavor_id       = var.flavor_id
  key_pair        = var.key_name
  security_groups = [var.secgroup_name]

  #network {
  #  uuid = var.net_id
  #}

  user_data = templatefile("${path.module}/user_data.yaml", {
    NODE_NUMBER = var.node_number
  })
}
