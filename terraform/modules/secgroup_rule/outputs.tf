output "http_rule_id" {
  description = "El ID de la regla de seguridad HTTP"
  value       = openstack_networking_secgroup_rule_v2.http_rule.id
}