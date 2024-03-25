variable external_network_name {}
variable network_name {}
variable subnetwork_name {}
variable router_name {}

# Declaración del resto de variables
variable server0_name {
    description = "The name of the server"
    type        = string
    default     = "Node0"
}

variable server1_name {
    description = "The name of the server"
    type        = string
    default     = "Node1"
}

variable server2_name {
    description = "The name of the server"
    type        = string
    default     = "Node2"
}

variable secgroup_name {
    description = "The name of the secgroup_name"
    type        = string
    default     = "proyecto11_secgroup"
}

variable "flavor_id" {
  description = "El ID del flavor para las instancias de servidor."
  type        = string
}

variable "pool" {
  description = "El nombre del pool de IPs flotantes."
  type        = string
}
