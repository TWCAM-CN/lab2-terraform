output "network_id" {
  description = "The ID of the created network."
  value       = module.networking.network_id
}

output "subnet_id" {
  description = "The ID of the created subnet."
  value       = module.networking.subnet_id
}

output "secgroup_id" {
  description = "The ID of the created security group."
  value       = module.secgroup.secgroup_id
}

output "server0_instance_id" {
  description = "The instance ID of server 0."
  value       = module.server0.instance_id
}

output "server0_name" {
  description = "The name of server 0."
  value       = module.server0.server_name
}

output "server1_instance_id" {
  description = "The instance ID of server 1."
  value       = module.server1.instance_id
}

output "server1_name" {
  description = "The name of server 1."
  value       = module.server1.server_name
}

output "server2_instance_id" {
  description = "The instance ID of server 2."
  value       = module.server2.instance_id
}

output "server2_name" {
  description = "The name of server 2."
  value       = module.server2.server_name
}

output "floating_ip_address" {
  description = "The floating IP address reserved for the infrastructure."
  value       = module.floating_ip.floating_ip_address
}

