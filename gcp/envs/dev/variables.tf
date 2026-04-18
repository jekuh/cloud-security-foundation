variable "environment" { type = string }
variable "name_prefix" { type = string }
variable "project_id" { type = string }
variable "region" { type = string }
variable "kms_key_name" {
  type        = string
  description = "KMS Key for bucket encryption"
  default     = null
  nullable    = true
}
