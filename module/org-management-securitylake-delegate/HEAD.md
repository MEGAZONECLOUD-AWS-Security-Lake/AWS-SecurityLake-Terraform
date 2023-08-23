# Terraform Module - AWS Organizations for Security Lake

> Note: In this Module is not a sub module. Use to be a standalone as root module.

This terraform module for AWS Organizations provisioning, then have an inner  python script running fot security lake delegation. Security lake delegation target account id is Organization member account. Should have to declare to specify member account with `securitylake_delegate` value is `True` in the `resources/member_account.yml`.

### Usage example

This terraform code execute after set the environment variable.<br>Must have to put the AWS CLI was configured profile name for organization management account in `PROFILE NAME`.

    
    export AWS_PROFILE="PROFILE NAME"

