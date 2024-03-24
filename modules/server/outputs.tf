output "server_id" {
  value = "${openstack_compute_instance_v2.server.id}"
  description = "The ID of the created server"
}