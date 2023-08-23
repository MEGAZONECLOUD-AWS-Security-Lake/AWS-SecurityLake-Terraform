# Terraform with CDK AWS Security Lake

> Note: In this Module is not a sub module. Use to be a standalone as root module.

This terraform module for AWS Security Lake enablement, then have an inner  python script running fot security lake enable.

### Usage example

This terraform code execute after set the environment variable.<br>Must have to put the AWS CLI was configured profile name for organization management account in `PROFILE NAME`.

    
    export AWS\_PROFILE="PROFILE NAME"

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_AmazonSecurityLakeS3BucketPermissionAppend_CloudTrail"></a> [AmazonSecurityLakeS3BucketPermissionAppend\_CloudTrail](#input\_AmazonSecurityLakeS3BucketPermissionAppend\_CloudTrail) | template file path | `string` | `"resources/AmazonSecurityLakeS3BucketPermission_CloudTrail_append.json.tftpl"` | no |
| <a name="input_AmazonSecurityLakeS3BucketPermissionAppend_Config"></a> [AmazonSecurityLakeS3BucketPermissionAppend\_Config](#input\_AmazonSecurityLakeS3BucketPermissionAppend\_Config) | template file path | `string` | `"resources/AmazonSecurityLakeS3BucketPermission_Config_append.json.tftpl"` | no |
| <a name="input_aws_config_configuration_aggregator_name"></a> [aws\_config\_configuration\_aggregator\_name](#input\_aws\_config\_configuration\_aggregator\_name) | n/a | `string` | `"securitylake_config_aggregator"` | no |
| <a name="input_aws_config_configuration_recorder_name"></a> [aws\_config\_configuration\_recorder\_name](#input\_aws\_config\_configuration\_recorder\_name) | (optional) describe your variable | `string` | `"securitylake_config_recorder"` | no |
| <a name="input_aws_config_delivery_channel_name"></a> [aws\_config\_delivery\_channel\_name](#input\_aws\_config\_delivery\_channel\_name) | n/a | `string` | `"securitylake_delivery_ch"` | no |
| <a name="input_region"></a> [region](#input\_region) | aws region name | `string` | `"ap-northeast-2"` | no |
| <a name="input_securitylake_cloudtrail_name"></a> [securitylake\_cloudtrail\_name](#input\_securitylake\_cloudtrail\_name) | Security Lake administrator cloudtrail name | `string` | `"securitylake_cloudtrail"` | no |
| <a name="input_securitylake_necessary_config_policy_name"></a> [securitylake\_necessary\_config\_policy\_name](#input\_securitylake\_necessary\_config\_policy\_name) | This Role for AWS Config service policy. | `string` | `"AmazoneSecurityLakeConfigPolicy"` | no |
| <a name="input_securitylake_necessary_config_role_name"></a> [securitylake\_necessary\_config\_role\_name](#input\_securitylake\_necessary\_config\_role\_name) | This Role for AWS Config service role. | `string` | `"AmazoneSecurityLakeConfigRole"` | no |
| <a name="input_securitylake_necessary_iam_policy_name"></a> [securitylake\_necessary\_iam\_policy\_name](#input\_securitylake\_necessary\_iam\_policy\_name) | Security Lake Meta Store Policy Name | `string` | `"AmazonSecurityLakeMetaStoreManagerPolicy"` | no |
| <a name="input_securitylake_necessary_iam_role_name"></a> [securitylake\_necessary\_iam\_role\_name](#input\_securitylake\_necessary\_iam\_role\_name) | Security Lake Meta Store Role Name | `string` | `"AmazonSecurityLakeMetaStoreManager"` | no |
| <a name="input_securitylake_rollup_region_necessary_policy_name"></a> [securitylake\_rollup\_region\_necessary\_policy\_name](#input\_securitylake\_rollup\_region\_necessary\_policy\_name) | This Policy for multi each region logged file integration to the security lake region. | `string` | `"AmazonSecurityLakeS3ReplicationRolePolicy"` | no |
| <a name="input_securitylake_rollup_region_necessary_role_name"></a> [securitylake\_rollup\_region\_necessary\_role\_name](#input\_securitylake\_rollup\_region\_necessary\_role\_name) | This Role for multi each region logged file integration to the security lake region. | `string` | `"AmazonSecurityLakeS3ReplicationRole"` | no |
| <a name="input_template_assume_role_policy"></a> [template\_assume\_role\_policy](#input\_template\_assume\_role\_policy) | template file path | `string` | `"resources/assume_role_policy.json.tftpl"` | no |
| <a name="input_template_iam_policy_AmazonSecurityLakeS3ReplicationPolicy"></a> [template\_iam\_policy\_AmazonSecurityLakeS3ReplicationPolicy](#input\_template\_iam\_policy\_AmazonSecurityLakeS3ReplicationPolicy) | template file path | `string` | `"resources/AmazonSecurityLakeS3ReplicationPolicy.json.tftpl"` | no |

## Outputs

No outputs.
