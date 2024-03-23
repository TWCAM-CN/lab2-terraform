output "server_id" {
  description = "The ID of the created server."
  value       = "${openstack_compute_instance_v2.server.id}
}
