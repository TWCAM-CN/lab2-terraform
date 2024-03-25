variable "external_network_name" {
  description = "The name of the external network."
}

variable "network_name" {
  description = "The name of the internal network."
}

variable "subnetwork_name" {
  description = "The name of the subnetwork."
}

variable "router_name" {
  description = "The name of the router."
}

variable "secgroup_name" {
  description = "The name of the security group."
}

variable "flavor_id" {
  description = "The flavor id for the server instances."
}

variable "key_name" {
  description = "The name of the key pair to use for the server instances."
}

variable "image_id" {
  description = "The ID of the image to use for the server instances."
}

variable "pool" {
  description = "The pool from which to obtain a floating IP."
}

variable "server0_name" {
  description = "The name of server 0."
}

variable "server1_name" {
  description = "The name of server 1."
}

variable "server2_name" {
  description = "The name of server 2."
}

variable "secgroup_description" {
  description = "Description for the security group."
}