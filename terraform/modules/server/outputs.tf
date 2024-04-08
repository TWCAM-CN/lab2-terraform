output "instance_id" {
  value = openstack_compute_instance_v2.instance.id
}

output "server_name" {
  description = "El nombre del servidor"
  value       = openstack_compute_instance_v2.instance.name
}