variable "kms_key_name" {
  type        = string
  description = "KMS Key for bucket encryption"
  default     = null
  nullable    = true
}
