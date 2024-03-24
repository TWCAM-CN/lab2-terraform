variable "secgroup_name" {
  description = "The name of the security group."
  type        = string
}

variable "secgroup_description" {
  description = "The description of the security group."
  type        = string
  default     = "Default description for the security group"
}
