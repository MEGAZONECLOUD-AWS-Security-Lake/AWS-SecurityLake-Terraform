# Security Lake Bucket policy update for CloudTrail
resource "aws_s3_bucket_policy" "security_lake" {
  bucket = data.aws_s3_bucket.security_lake.id

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = local.securitylake_bucket_policy_append
  })

  lifecycle {
    ignore_changes = ["policy"]
  }
}

/* resource "aws_cloudtrail" "cloudtrail" {
  name           = var.securitylake_cloudtrail_name
  s3_bucket_name = data.aws_s3_bucket.security_lake.id
  s3_key_prefix  = ""

  event_selector {
    include_management_events = true
    read_write_type           = "All"
  }
  enable_logging                = true
  include_global_service_events = true
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  is_organization_trail         = true

  depends_on = [
    aws_s3_bucket_policy.cloudtrail,
    data.external.aws_security_lake_enable
  ]
} */
