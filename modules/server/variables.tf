variable "server_name" {
  description = "The name of the server."
  type        = string  
}

variable "image_id" {
  description = "The image ID to use for the server."
  type        = string
  default     = "8c36a029-c5eb-422a-8b18-92b3052f550e"
}

variable "flavor_id" {
  description = "El ID del flavor para las instancias de servidor"
  type        = string
  default     = "a539e505-4d54-47f4-b790-394353e51551" // openstack flavor list
}

variable "key_name" {
  description = "The name of the key pair to associate with the server."
  type        = string
  default     = "proyecto11-claves" // openstack keypair list
}

variable "secgroup_name" {
  description = "El nombre del grupo de seguridad para asociar con el servidor"
  type        = string
}

variable "node_number" {
  description = "El número del nodo para el servidor"
  type        = string
}