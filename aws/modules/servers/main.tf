variable "environment" { type = string }
variable "name_prefix" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_security_group" "app" {
  name   = "${var.name_prefix}-${var.environment}-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  servers = {
    app-1 = {
      subnet_id = var.public_subnet_ids[0]
      public_ip = true
    }
    app-2 = {
      subnet_id = var.public_subnet_ids[1]
      public_ip = true
    }
    app-3 = {
      subnet_id = var.public_subnet_ids[0]
      public_ip = true
    }
    app-4 = {
      subnet_id = var.private_subnet_ids[0]
      public_ip = false
    }
    app-5 = {
      subnet_id = var.private_subnet_ids[1]
      public_ip = false
    }
    app-6 = {
      subnet_id = var.private_subnet_ids[0]
      public_ip = false
    }
  }
}

resource "aws_instance" "app" {
  for_each = local.servers

  ami                         = data.aws_ami.al2023.id
  instance_type               = "t3.micro"
  subnet_id                   = each.value.subnet_id
  associate_public_ip_address = each.value.public_ip
  vpc_security_group_ids      = [aws_security_group.app.id]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device { encrypted = true }

  tags = { Name = "${var.name_prefix}-${var.environment}-${each.key}" }
}
