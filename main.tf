data "aws_iam_openid_connect_provider" "hcp_terraform" {
  arn = var.oidc_provider_arn
}

data "aws_iam_policy_document" "hcp_oidc_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.hcp_terraform.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "app.terraform.io:aud"
      values   = ["aws.workload.identity"]
    }

    condition {
      test     = "StringLike"
      variable = "app.terraform.io:sub"
      # Allows role to be used for any work done in the organization.
      values = ["organization:*"]
    }
  }
}

resource "aws_iam_role" "lambda_apigw_full_access" {
  name               = "lambda-apigw-full-access-role"
  assume_role_policy = data.aws_iam_policy_document.hcp_oidc_assume_role_policy.json
}

data "aws_iam_policy" "lambda_apigw_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_apigw_full_access" {
  policy_arn = data.aws_iam_policy.lambda_apigw_full_access.arn
  role       = aws_iam_role.lambda_apigw_full_access.name
}

resource "tfe_variable_set" "lambda_apigw_role_var_set" {
  name         = aws_iam_role.lambda_apigw_full_access.name
  description  = "OIDC federation configuration for ${aws_iam_role.lambda_apigw_full_access.arn}"
  organization = var.hcp_organization_name
}

resource "tfe_variable" "tfc_aws_provider_auth" {
  key             = "TFC_AWS_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.lambda_apigw_role_var_set.id
}

resource "tfe_variable" "tfc_aws_run_role_arn" {
  sensitive       = true
  key             = "TFC_AWS_RUN_ROLE_ARN"
  value           = aws_iam_role.lambda_apigw_full_access.arn
  category        = "env"
  variable_set_id = tfe_variable_set.lambda_apigw_role_var_set.id
}
