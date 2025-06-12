# hcp-tf-aws-lambda-apigw-role

Creates AWS IAM Role with permissions for Lambda and API Gateway for use with HCP Terraform runs.

## Usage

Inject the IAM role with Lambda/APIGW permissions into a new HCP Terraforrm workspace...

1. Create a new `tfe_workspace_variable_set` in [workspaces.tf](./workspaces.tf)
2. Set the value of `workspace_id` to the ID of the workspace that needs to consume this role

## Deployment

Pushing to this repo triggers a GitHub Actions run that deploys the Terraform config via HCP Terraform.

There are no dev/prod environment distinctions in this config as the created IAM role and HCP resources will be provisioned in enpicie's singular AWS and HCP accounts respectively.

The pipeline will trigger on push to any branch. After the intial development is done to configure the IAM role, this config will only need to re-run when it needs to inject the HCP variable referencing the role into a new HCP workspace.

## Setup

This config consumes the OIDC provider and IAM role with permissions to create IAM resources deployed via CloudFormation template in [aws-terraform-oidc-config](https://github.com/chzylee/aws-terraform-oidc-config).

Relevant inputs for this config are configured in [terraform.tfvars](./terraform.tfvars) for easy configurability.
