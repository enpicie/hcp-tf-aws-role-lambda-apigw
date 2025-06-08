data "aws_iam_openid_connect_provider" "hcp_terraform" {
  arn = var.oidc_provider_arn
}
