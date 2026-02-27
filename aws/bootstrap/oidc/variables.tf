variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "github_org" { type = string }

variable "github_repo" { type = string }

variable "state_bucket_name" { type = string }

variable "lock_table_name" {
  type    = string
  default = "terraform-locks"
}

variable "role_name_prefix" {
  type    = string
  default = "gh-actions-terraform"
}
