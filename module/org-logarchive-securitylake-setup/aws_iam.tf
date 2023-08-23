# https://docs.aws.amazon.com/security-lake/latest/userguide/manage-regions.html#iam-role-replication

resource "aws_iam_role" "AmazonSecurityLakeS3ReplicationRole" {

  name = var.securitylake_rollup_region_necessary_role_name

  assume_role_policy = templatefile(var.template_assume_role_policy, {
    principal_service = "s3.amazonaws.com"
    action            = "sts:AssumeRole"
  })
}

resource "aws_iam_policy" "AmazonSecurityLakeS3ReplicationPolicy" {

  name        = var.securitylake_rollup_region_necessary_policy_name
  description = "This Policy for multi each region logged file integration to the security lake region."

  policy = templatefile(var.template_iam_policy_AmazonSecurityLakeS3ReplicationPolicy, {
    account_id = tostring(data.aws_caller_identity.current.account_id)
  })
}


resource "aws_iam_role_policy_attachment" "AmazonSecurityLakeS3ReplicationRole" {
  role       = aws_iam_role.AmazonSecurityLakeS3ReplicationRole.name
  policy_arn = aws_iam_policy.AmazonSecurityLakeS3ReplicationPolicy.arn
}




# AmazoneSecurityLakeConfig Role and Policy
resource "aws_iam_role" "AmazoneSecurityLakeConfigRole" {
  name = var.securitylake_necessary_config_role_name
  assume_role_policy = templatefile(var.template_assume_role_policy, {
    principal_service = "config.amazonaws.com"
    action            = "sts:AssumeRole"
  })
}

resource "aws_iam_role_policy" "AmazoneSecurityLakeConfigPolicy" {
  name = var.securitylake_necessary_config_policy_name
  role = aws_iam_role.AmazoneSecurityLakeConfigRole.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${data.aws_s3_bucket.security_lake.arn}",
        "${data.aws_s3_bucket.security_lake.arn}/*"
      ]
    }
  ]
}
EOF
}
