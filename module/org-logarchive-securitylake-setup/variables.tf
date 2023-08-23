variable "region" {
  description = "aws region name"
  type        = string
  default     = "ap-northeast-2"
}

variable "securitylake_necessary_iam_policy_name" {
  type        = string
  description = "Security Lake Meta Store Policy Name"
  default     = "AmazonSecurityLakeMetaStoreManagerPolicy"
}

variable "securitylake_necessary_iam_role_name" {
  type        = string
  description = "Security Lake Meta Store Role Name"
  default     = "AmazonSecurityLakeMetaStoreManager"
}

variable "securitylake_rollup_region_necessary_role_name" {
  type        = string
  description = "This Role for multi each region logged file integration to the security lake region."
  default     = "AmazonSecurityLakeS3ReplicationRole"
}

variable "securitylake_rollup_region_necessary_policy_name" {
  type        = string
  description = "This Policy for multi each region logged file integration to the security lake region."
  default     = "AmazonSecurityLakeS3ReplicationRolePolicy"
}

variable "securitylake_necessary_config_role_name" {
  type        = string
  description = "This Role for AWS Config service role."
  default     = "AmazoneSecurityLakeConfigRole"
}

variable "securitylake_necessary_config_policy_name" {
  type        = string
  description = "This Role for AWS Config service policy."
  default     = "AmazoneSecurityLakeConfigPolicy"
}

variable "securitylake_cloudtrail_name" {
  type        = string
  description = "Security Lake administrator cloudtrail name"
  default     = "securitylake_cloudtrail"
}

variable "template_assume_role_policy" {
  type        = string
  description = "template file path"
  default     = "resources/assume_role_policy.json.tftpl"
}

variable "template_iam_policy_AmazonSecurityLakeS3ReplicationPolicy" {
  type        = string
  description = "template file path"
  default     = "resources/AmazonSecurityLakeS3ReplicationPolicy.json.tftpl"
}
variable "AmazonSecurityLakeS3BucketPermissionAppend_CloudTrail" {
  type        = string
  description = "template file path"
  default     = "resources/AmazonSecurityLakeS3BucketPermission_CloudTrail_append.json.tftpl"
}
variable "AmazonSecurityLakeS3BucketPermissionAppend_Config" {
  type        = string
  description = "template file path"
  default     = "resources/AmazonSecurityLakeS3BucketPermission_Config_append.json.tftpl"
}
variable "aws_config_configuration_recorder_name" {
  type        = string
  description = "(optional) describe your variable"
  default     = "securitylake_config_recorder"
}
variable "aws_config_delivery_channel_name" {
  type    = string
  default = "securitylake_delivery_ch"
}
variable "aws_config_configuration_aggregator_name" {
  type    = string
  default = "securitylake_config_aggregator"
}