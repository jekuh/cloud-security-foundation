terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}
provider "aws" { region = var.aws_region }

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_org}/${var.github_repo}:*"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "${var.role_name_prefix}-${var.github_repo}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "state_access" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.state_bucket_name}"]
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${var.state_bucket_name}/*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem", "dynamodb:UpdateItem", "dynamodb:DescribeTable"]
    resources = ["arn:aws:dynamodb:*:*:table/${var.lock_table_name}"]
  }
}

data "aws_iam_policy_document" "mvp_provisioning" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:*", "iam:*", "s3:*", "logs:*", "cloudwatch:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "state_access" {
  name   = "${var.role_name_prefix}-${var.github_repo}-state"
  policy = data.aws_iam_policy_document.state_access.json
}

resource "aws_iam_policy" "mvp_provisioning" {
  name   = "${var.role_name_prefix}-${var.github_repo}-mvp"
  policy = data.aws_iam_policy_document.mvp_provisioning.json
}

resource "aws_iam_role_policy_attachment" "state_access" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.state_access.arn
}

resource "aws_iam_role_policy_attachment" "mvp_provisioning" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.mvp_provisioning.arn
}
