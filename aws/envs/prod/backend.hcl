bucket         = "mb-terraform-state-2026"
key            = "aws/prod/terraform.tfstate"
region         = "eu-central-1"
dynamodb_table = "terraform-locks"
encrypt        = true
