variable "security_group_id" {}
variable "from_port_http" {}
variable "to_port_http" {}
variable "protocol_http" {
  default = "http"
}
variable "direction" {
  default = "ingress"
}
variable "ethertype" {
  default = "IPv4"
}
