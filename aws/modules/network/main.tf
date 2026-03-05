
variable "name_prefix" { type = string }
variable "environment" { type = string }


resource "aws_vpc" "app" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "${var.name_prefix}-${var.environment}-vpc"
  }

}