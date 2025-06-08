# hcp-tf-aws-lambda-apigw-role

Creates AWS IAM Role with permissions for Lambda and API Gateway for use with HCP Terraform runs.

## Usage

Pushing to this repo triggers a GitHub Actions run that deploys the Terraform config via HCP Terraform.

There are no dev/prod environment distinctions in this config as the created IAM role and HCP resources will be provisioned in enpicie's singular AWS and HCP accounts respectively.

## Setup

This config consumes the OIDC provider and IAM role with permissions to create IAM resources deployed via CloudFormation template in [aws-terraform-oidc-config](https://github.com/chzylee/aws-terraform-oidc-config)
