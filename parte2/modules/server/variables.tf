variable "image_id" {}
variable "flavor_id" {}
variable "network_id" {}
variable "secgroup_id" {}
variable "key_name" {}
variable "node_number" {
  description = "El número del nodo para personalizar la configuración de user data."
  type        = string
}
variable "server_name" {
  description = "The name of the server instance."
  type        = string
}
