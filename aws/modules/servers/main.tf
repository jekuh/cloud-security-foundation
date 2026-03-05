variable "environment" { type = string }
variable "name_prefix" { type = string }
variable "vpc_id" { type = string }


resource "aws_instance" "ubuntu" {
  ami           = "ami-01f79b1e4a5c64257"
  instance_type = "t3.micro"

  tags = {
    Name = "${var.name_prefix}-${var.environment}-ubuntu"
  }

}

resource "aws_instance" "windows" {
  ami           = "ami-0e3af9e89c78d4b08"
  instance_type = "t3.micro"

  tags = {
    Name = "${var.name_prefix}-${var.environment}-windows"
  }

}

