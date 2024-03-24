variable "server_name" {
  description = "The name of the server."
}

variable "image_id" {
  description = "The image ID to use for the server."
}

variable "flavor_id" {
  description = "The flavor ID to define the size of the server."
}

variable "key_name" {
  description = "The name of the key pair to associate with the server."
}

variable "secgroup_name" {
  description = "The name of the security group to associate with the server."
}

variable "net_id" {
  description = "The ID of the network to which the server will be attached."
}

variable "user_data_file" {
  description = "The user data file to configure the server on boot."
}


variable "node_number" {
  description = "Node identifier for the instance"
  type        = string
}