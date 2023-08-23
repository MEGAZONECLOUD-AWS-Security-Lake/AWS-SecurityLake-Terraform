# Provider variables
aws_region = "ap-northeast-2"

# AWS Organizations enable variables
aws_service_access_principals = [
  "securitylake.amazonaws.com",
  "access-analyzer.amazonaws.com",
  "cloudtrail.amazonaws.com",
  "config.amazonaws.com",
  "config-multiaccountsetup.amazonaws.com",
  "securityhub.amazonaws.com"
]
# enabled_policy_types = [ "AISERVICES_OPT_OUT_POLICY", "BACKUP_POLICY", "SERVICE_CONTROL_POLICY", "TAG_POLICY"]
org_member_account_list_file = "resources/member_account.yml"