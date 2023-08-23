resource "random_string" "random_suffix" {
  length  = 8
  special = false
  upper   = false
}

locals {
  securitylake_bucket_name = "aws-security-data-lake-${data.aws_region.current.name}-${random_string.random_suffix.result}"
  securitylake_bucket_policy_append = concat(
    jsondecode(data.aws_s3_bucket_policy.security_lake.policy)["Statement"],
    jsondecode(
      templatefile(
        var.AmazonSecurityLakeS3BucketPermissionAppend_CloudTrail, {
          bucket_arn      = data.aws_s3_bucket.security_lake.arn,
          region          = data.aws_region.current.name,
          organization_id = data.aws_organizations_organization.current.id,
          cloudtrail_name = var.securitylake_cloudtrail_name,
          account_id      = "603295374463"
        }
      )
    ),
    jsondecode(
      templatefile(
        var.AmazonSecurityLakeS3BucketPermissionAppend_Config, {
          bucket_arn = data.aws_s3_bucket.security_lake.arn,
          account_id = data.aws_caller_identity.current.account_id
        }
      )
    )
  )
}