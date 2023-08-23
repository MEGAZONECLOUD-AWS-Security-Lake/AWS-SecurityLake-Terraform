data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_organizations_organization" "current" {}
data "external" "aws_security_lake_enable" {
  program = [
    "python3",
    "scripts/aws-security-lake-enable.py",
    "--asl_necessary_iam_policy_name",
    var.securitylake_necessary_iam_policy_name,
    "--asl_necessary_iam_role_name",
    var.securitylake_necessary_iam_role_name,
    "--asl_region",
    data.aws_region.current.name
  ]
}

data "aws_iam_role" "securitylake_necessary_iam_role" {
  name = var.securitylake_necessary_iam_role_name
  depends_on = [
    data.external.aws_security_lake_enable,
    data.aws_caller_identity.current
  ]
}

data "aws_iam_policy" "securitylake_necessary_iam_policy" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.securitylake_necessary_iam_policy_name}"
  depends_on = [
    data.external.aws_security_lake_enable,
    data.aws_caller_identity.current
  ]
}

data "aws_s3_bucket" "security_lake" {
  bucket     = element(split(":", data.external.aws_security_lake_enable.result.s3BucketArn), 5)
  depends_on = [data.external.aws_security_lake_enable]
}

data "aws_s3_bucket_policy" "security_lake" {
  bucket     = element(split(":", data.external.aws_security_lake_enable.result.s3BucketArn), 5)
  depends_on = [data.external.aws_security_lake_enable]
}