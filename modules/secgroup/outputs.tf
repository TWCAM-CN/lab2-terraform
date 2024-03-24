output "proyecto11_security_group_id" {
    description = "The ID of the security group"
    value       = "${openstack_networking_secgroup_v2.proyecto11_secgroup.id}"
}

output "secgroup_id" {
  description = "El ID del grupo de seguridad"
  value       = openstack_networking_secgroup_v2.proyecto11_secgroup.id
}