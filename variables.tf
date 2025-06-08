variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2" # Ohio
}

variable "oidc_provider_arn" {
  description = "ARN of the existing OIDC provider"
  type        = string
}
