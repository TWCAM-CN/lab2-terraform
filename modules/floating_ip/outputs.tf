output "floating_ip_address" {
  description = "The assigned floating IP address."
  value       = openstack_networking_floatingip_v2.floating_ip.address
}
