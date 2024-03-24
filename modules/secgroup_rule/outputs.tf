// modules/secgroup_rules/outputs.tf
output "http_rule_id" {
    description = "The ID of the http security group rule"
    value       = openstack_networking_secgroup_rule_v2.http_rule.id
}

output "icmp_rule_id" {
    description = "The ID of the icmp security group rule"
    value       = openstack_networking_secgroup_rule_v2.icmp_rule.id
}