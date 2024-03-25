variable "pool" {
  description = "El nombre del pool de IPs flotantes."
  type        = string
}

variable "instance_id" {
  description = "The ID of the instance to associate the floating IP with."
}
