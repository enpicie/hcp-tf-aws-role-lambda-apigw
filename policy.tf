resource "aws_iam_policy" "lambda_apigw_full_access" {
  name        = "TerraformLambdaAPIGWFullAccess"
  description = "Allows HCP Terraform to provision AWS Lambda and API Gateway resources"
  path        = "/"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "LambdaFullAccess",
        Effect = "Allow",
        Action = [
          "lambda:*"
        ],
        Resource = "*"
      },
      {
        Sid    = "APIGatewayFullAccess",
        Effect = "Allow",
        Action = [
          "apigateway:*"
        ],
        Resource = "*"
      },
      {
        Sid    = "PassRoleForLambda",
        Effect = "Allow",
        # Allows passing execution roles to Lambda functions.
        Action   = "iam:PassRole",
        Resource = "*",
        Condition = {
          StringLikeIfExists = {
            "iam:PassedToService" = "lambda.amazonaws.com"
          }
        }
      },
      {
        # Needed to provision logging groups for Lambda functions.
        Sid    = "CloudWatchLogs",
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}
