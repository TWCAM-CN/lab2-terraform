// modules/secgroup_rules/variables.tf
variable "from_port_http" {
    description = "The start port for the http rule"
    type        = number
    default     = 80
}

variable "to_port_http" {
    description = "The end port for the http rule"
    type        = number
    default     = 80
}

variable "protocol_http" {
    description = "The protocol for the http rule"
    type        = string
    default     = "tcp"
}

variable "protocol_icmp" {
    description = "The protocol for the icmp rule"
    type        = string
    default     = "icmp"
    
}

variable "direction" {
    description = "The direction of the security group rule"
    type        = string
    default     = "ingress"
}

variable "ethertype" {
    description = "The ethertype of the security group rule"
    type        = string
    default     = "IPv4"
}

variable "security_group_id" {
    description = "The ID of the security group to which the rule will be added"
    type        = string
}