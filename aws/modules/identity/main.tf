variable "environment" { type = string }
variable "name_prefix" { type = string }
data "aws_iam_policy_document" "assume_ec2" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "app" {
  name               = "${var.name_prefix}-${var.environment}-app-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ec2.json
}


