variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "state_bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name for Terraform remote state"
}

variable "lock_table_name" {
  type    = string
  default = "terraform-locks"
}