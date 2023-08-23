resource "aws_config_configuration_recorder" "security_lake" {
  name     = var.aws_config_configuration_recorder_name
  role_arn = aws_iam_role.AmazoneSecurityLakeConfigRole.arn
  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "security_lake" {
  name           = var.aws_config_delivery_channel_name
  s3_bucket_name = element(split(":", data.external.aws_security_lake_enable.result.s3BucketArn), 5)
  depends_on     = [aws_s3_bucket_policy.security_lake, aws_config_configuration_recorder.security_lake]
}

resource "aws_config_configuration_recorder_status" "security_lake" {
  name       = aws_config_configuration_recorder.security_lake.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.security_lake]
}

resource "aws_config_aggregate_authorization" "security_lake" {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}
resource "aws_config_configuration_aggregator" "security_lake" {
  depends_on = [aws_config_configuration_recorder.security_lake]

  name = var.aws_config_configuration_aggregator_name

  organization_aggregation_source {
    all_regions = true
    role_arn    = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig"
  }
}

