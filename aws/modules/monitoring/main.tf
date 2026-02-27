variable "environment" { type = string }
variable "name_prefix" { type = string }
resource "aws_cloudwatch_log_group" "app" {
  name              = "/${var.name_prefix}/${var.environment}/app"
  retention_in_days = 30
}
