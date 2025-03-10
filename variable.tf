variable "access_key" {
    type = string
    description = "aws access key value"
}

variable "secret_key" {
    type = string
    description = "aws secret key value"
}
variable "ami_id" {
  type        = string
  description = "The AMI ID to use for the instance"
}

variable "instance_type" {
  type        = string
  description = "The instance type to use"
}

variable "instance_name" {
  type        = string
  description = "The instance name to use"
}

variable "is_instance_create" {
    type = bool
    default = false
    description = "Toggle whether to create instance or not"
  
}

variable "latest_ami" {
    type = bool
    default = false
    description = "Toggle whether to create instance or not"
  
}