# MEGAZONECLOUD AWS Secrity Lake - Terraform Template

This Terraform template target for AWS Security Lake service enablement on AWS Organizations. This repository have two module for the AWS services enabling and setup by each organization account. Let's look at below guide.

## Management Account on AWS Organizations

First of all, when need to enable the Security Lake service Management account should have delegation to a Member account like a Log Account of OU. Thus, this Terraform code basically enables the AWS Organization service then create an OU and create a member account with a specific member account such as a Log Archive role. 

Please refer to this [README](module/org-management-securitylake-delegate/README.md)

```
module/org-management-securitylake-delegate/
├── HEAD.md
├── README.md
├── aws-org-administrators-delegation.tf
├── aws-organizations.tf
├── aws-securitylake.tf
├── datas.tf
├── locals.tf
├── resources
│   ├── aws_s3_cloudtrail_permission.json.tftpl
│   └── member_account.yml
├── scripts
│   └── aws-securitylake-delegation.py
├── terraform.tf
├── variables.auto.tfvars
└── variables.tf
```

## Log Archive Member Account in AWS Organizations

This module for AWS Security Lake enabling and Service Role setup on member account for Log Archive Role.

Please refer to this [README](module/org-logarchive-securitylake-setup/README.md)

```
module/org-logarchive-securitylake-setup/
├── HEAD.md
├── README.md
├── aws_cloudtrail.tf
├── aws_config.tf
├── aws_iam.tf
├── datas.tf
├── locals.tf
├── resources
│   ├── AmazonSecurityLakeS3BucketPermission_CloudTrail_append.json.tftpl
│   ├── AmazonSecurityLakeS3BucketPermission_Config_append.json.tftpl
│   ├── AmazonSecurityLakeS3ReplicationPolicy.json.tftpl
│   ├── EmptyStatement.json.tftpl
│   └── assume_role_policy.json.tftpl
├── scripts
│   └── aws-security-lake-enable.py
├── securityhub.tf
├── terraform.tf
├── variable.auto.tfvars
└── variables.tf
```