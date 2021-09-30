# This is where you put your resource declaration

locals {
  name   = "octopus deploy role"
  tags = {
    Owner       = "Dave Moreno"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy" "octopus_policy" {
  name = "octopus_deploy_policy"
  role = aws_iam_role.octopus_iam_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudformation:CreateStack",
          "cloudformation:DescribeStacks",
          "cloudformation:DeleteStack",
          "cloudformation:DescribeStackEvents",
          "cloudformation:UpdateStack",
          "iam:PassRole",
          "appsync:*",
          "cloudfront:*",
          "dynamodb:*",
          "lambda:*",
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

data "aws_iam_policy_document" "octopus-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::516289930457:root"]
    }
  }
}

resource "aws_iam_role" "octopus_iam_role" {
  name               = "octopus_deploy"
  assume_role_policy = data.aws_iam_policy_document.octopus-assume-role-policy.json
  tags = local.tags
}
