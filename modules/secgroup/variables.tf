variable "security_group_name" {
  description = "The name of the security group."
  type        = string
}

variable "security_group_description" {
  description = "The description of the security group."
  type        = string
  default     = "Default description for the security group"
}
