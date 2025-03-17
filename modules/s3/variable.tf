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