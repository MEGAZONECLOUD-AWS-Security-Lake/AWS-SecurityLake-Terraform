# Terraform Module - AWS Organizations for Security Lake

> Note: In this Module is not a sub module. Use to be a standalone as root module.

This terraform module for AWS Organizations provisioning, then have an inner  python script running fot security lake delegation. Security lake delegation target account id is Organization member account. Should have to declare to specify member account with `securitylake_delegate` value is `True` in the `resources/member_account.yml`.

### Usage example

This terraform code execute after set the environment variable.<br>Must have to put the AWS CLI was configured profile name for organization management account in `PROFILE NAME`.

    
    export AWS\_PROFILE="PROFILE NAME"

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | aws region name | `string` | n/a | yes |
| <a name="input_aws_service_access_principals"></a> [aws\_service\_access\_principals](#input\_aws\_service\_access\_principals) | (Optional) List of AWS service principal names for which you want to enable integration with your organization. This is typically in the form of a URL, such as service-abbreviation.amazonaws.com. Organization must have feature\_set set to ALL. Some services do not support enablement via this endpoint, see warning in aws docs: https://docs.aws.amazon.com/organizations/latest/APIReference/API_EnableAWSServiceAccess.html | `list(any)` | `[]` | no |
| <a name="input_cloudtrail_name"></a> [cloudtrail\_name](#input\_cloudtrail\_name) | cloudtrain name | `string` | `"management-events"` | no |
| <a name="input_enabled_policy_types"></a> [enabled\_policy\_types](#input\_enabled\_policy\_types) | (Optional) List of Organizations policy types to enable in the Organization Root. Organization must have feature\_set set to ALL. For additional information about valid policy types (e.g., AISERVICES\_OPT\_OUT\_POLICY, BACKUP\_POLICY, SERVICE\_CONTROL\_POLICY, and TAG\_POLICY), see the AWS Organizations API Reference: https://docs.aws.amazon.com/organizations/latest/APIReference/API_EnablePolicyType.html | `list(any)` | `[]` | no |
| <a name="input_org_member_account_list_file"></a> [org\_member\_account\_list\_file](#input\_org\_member\_account\_list\_file) | aws organization member account list file path | `string` | n/a | yes |

## Outputs

No outputs.
