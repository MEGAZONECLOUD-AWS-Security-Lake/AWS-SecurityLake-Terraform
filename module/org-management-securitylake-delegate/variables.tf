variable "aws_region" {
  description = "aws region name"
  type        = string
}

variable "aws_service_access_principals" {
  type        = list(any)
  description = "(Optional) List of AWS service principal names for which you want to enable integration with your organization. This is typically in the form of a URL, such as service-abbreviation.amazonaws.com. Organization must have feature_set set to ALL. Some services do not support enablement via this endpoint, see warning in aws docs: https://docs.aws.amazon.com/organizations/latest/APIReference/API_EnableAWSServiceAccess.html"
  default     = []
}

variable "enabled_policy_types" {
  type        = list(any)
  description = "(Optional) List of Organizations policy types to enable in the Organization Root. Organization must have feature_set set to ALL. For additional information about valid policy types (e.g., AISERVICES_OPT_OUT_POLICY, BACKUP_POLICY, SERVICE_CONTROL_POLICY, and TAG_POLICY), see the AWS Organizations API Reference: https://docs.aws.amazon.com/organizations/latest/APIReference/API_EnablePolicyType.html"
  default     = []
}

variable "org_member_account_list_file" {
  description = "aws organization member account list file path"
  type        = string
}

variable "cloudtrail_name" {
  type        = string
  description = "cloudtrain name"
  default     = "management-events"
}