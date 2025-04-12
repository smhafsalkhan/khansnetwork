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
variable "create_bucket" {
  description = "Set to true to create the S3 bucket and all related resources"
  type        = bool
  default     = false
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}