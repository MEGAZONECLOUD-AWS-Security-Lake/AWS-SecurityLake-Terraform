#!/usr/bin/env python3
import sys
import subprocess
import json
import logging
import argparse
logger = logging.getLogger(__name__)

# install additional module
def install(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

try:
    import boto3
except:
    install("boto3")
finally:    
    import boto3

from botocore.exceptions import ClientError



def get_session(**kwargs):
    session = boto3.session.Session()
    return session.client(kwargs['allowed_services'])


def list_roles(**kwargs):
    iam_role_list = []

    if "count" not in kwargs:
        count = 1000
    try:
        role_list = iam.list_roles(
            # PathPrefix='string',
            # Marker='string',
            MaxItems=count
        )
        for role in role_list['Roles']:
            logger.info("Role: %s", role["RoleName"])
            iam_role_list.append({ 'RoleName': role["RoleName"], 'Arn': role["Arn"],'RoleId': role['RoleId']})
    except ClientError:
        logger.exception("Couldn't list roles for the account.")
        raise
    else:
        return iam_role_list

def list_policies(**kwargs):
    iam_policy_list = []

    if "count" not in kwargs:
        count = 1000
    try:
        policy_list = iam.list_policies(
            Scope = "Local",
            MaxItems=count
        )
        for policy in policy_list['Policies']:
            iam_policy_list.append({ 'PolicyName': policy["PolicyName"], 'Arn': policy["Arn"],'PolicyId': policy['PolicyId']})
    except ClientError:
        logger.exception("Couldn't list policies for the account.")
        raise
    else:
        return iam_policy_list
        
def create_role(role_name, allowed_services):

    trust_policy = {
        'Version': '2012-10-17',
        'Statement': [{
                'Effect': 'Allow',
                'Principal': {'Service': service},
                'Action': 'sts:AssumeRole'
            } for service in allowed_services
        ]
    }    

    try:
        
        was_created_roles = list_roles()
        
        for role in was_created_roles:
            if role_name == role["RoleName"]:
                return {"Role": role} 
        
        role = iam.create_role(
            RoleName=role_name,
            AssumeRolePolicyDocument=json.dumps(trust_policy))
        logger.info("Created role %s.", role_name)

    except ClientError:
        logger.exception("Couldn't create role %s.", role_name)
        raise

    else:
        return role

def create_policy(name, description):
    
    policy_doc = {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Sid": "AllowWriteLambdaLogs",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                f"arn:aws:logs:*:{account_id}:log-group:/aws/lambda/SecurityLake_Glue_Partition_Updater_Lambda*"
            ]
            },
            {
            "Sid": "AllowCreateAwsCloudWatchLogGroup",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup"
            ],
            "Resource": [
                f"arn:aws:logs:*:{account_id}:/aws/lambda/SecurityLake_Glue_Partition_Updater_Lambda*"
            ]
            },
            {
            "Sid": "AllowGlueManage",
            "Effect": "Allow",
            "Action": [
                "glue:CreatePartition",
                "glue:BatchCreatePartition"
            ],
            "Resource": [
                "arn:aws:glue:*:*:table/amazon_security_lake_glue_db*/*",
                "arn:aws:glue:*:*:database/amazon_security_lake_glue_db*",
                "arn:aws:glue:*:*:catalog"
            ]
            },
            {
            "Sid": "AllowToReadFromSqs",
            "Effect": "Allow",
            "Action": [
                "sqs:ReceiveMessage",
                "sqs:DeleteMessage",
                "sqs:GetQueueAttributes"
            ],
            "Resource": [
                f"arn:aws:sqs:*:{account_id}:SecurityLake*"
            ]
            }
        ]
    }
    try:
        was_created_policies = list_policies()
        
        for policy in was_created_policies:
            if policy["PolicyName"] == name:
                return {"Policy": policy}

        policy = iam.create_policy(
            PolicyName=name, Description=description,
            PolicyDocument=json.dumps(policy_doc))
        # logger.info("Created policy %s.", policy.arn)
    except ClientError:
        logger.exception("Couldn't create policy %s.", name)
        raise
    else:
        return policy

def do_1():
    return 0

# Define the variables
# aws_profile = "logarchive" # Should have to be use environment variable "AWS_PROFILE"

# arguments parser
parser = argparse.ArgumentParser()
parser.add_argument('--asl_necessary_iam_policy_name',type=str, required=True, help="Security Lake Meta Store Policy Name")
parser.add_argument('--asl_necessary_iam_role_name',type=str, required=True, help="Security Lake Meta Store Role Name")
parser.add_argument('--asl_region',type=str, required=True, help="Security Lake Region Name")
args    = parser.parse_args()


asl_necessary_iam_policy_name = args.asl_necessary_iam_policy_name
asl_necessary_iam_role_name = args.asl_necessary_iam_role_name
asl_region = args.asl_region


if __name__ == "__main__":
    # Role and Policy arrangements
    # get IAM session
    iam =  get_session(allowed_services = "iam")

    # get Account ID
    account_id = get_session(allowed_services = "sts").get_caller_identity().get('Account')
    # Create Policy

    asl_necessary_iam_policy_create = create_policy(name=asl_necessary_iam_policy_name, description="")

    # Create Role
    asl_necessary_iam_role_create = create_role(asl_necessary_iam_role_name,["lambda.amazonaws.com"])

    # Attach Policy to Role
    iam.attach_role_policy(
        PolicyArn=asl_necessary_iam_policy_create['Policy']['Arn'],
        RoleName=asl_necessary_iam_role_name
    )

    asl_session =  get_session(allowed_services = "securitylake")

    
    if len(asl_session.list_data_lakes(regions=[asl_region])["dataLakes"]) == 0:
    
        asl_enable_response = asl_session.create_data_lake(
            configurations=[
                {
                    'region': asl_region,
                },
            ],
            metaStoreManagerRoleArn=asl_necessary_iam_role_create["Role"]["Arn"],
        )
    
    # def asl_enable_progress_check
    asl_progress = ""
    while asl_progress != "COMPLETED":
        asl_enable_progress = asl_session.list_data_lakes(regions=[asl_region])["dataLakes"]
        if len(asl_enable_progress) >0 and asl_enable_progress[0].get("createStatus") is not None:
            asl_progress = asl_enable_progress[0]["createStatus"]
            
    security_lake_enable_result = {}    
    security_lake_enable_result["dataLakeArn"] = asl_enable_progress[0]["dataLakeArn"]
    security_lake_enable_result["region"] = asl_enable_progress[0]["region"]
    security_lake_enable_result["s3BucketArn"] = asl_enable_progress[0]["s3BucketArn"]
    #
    asl_organization_configuration_response = asl_session.create_data_lake_organization_configuration(
        autoEnableNewAccount=[
            {
                'region': asl_region,
                'sources': [
                    {
                        'sourceName': 'ROUTE53'
                    },
                    {
                        'sourceName': 'VPC_FLOW'
                    },
                    {
                        'sourceName': 'SH_FINDINGS'
                    },
                    {
                        'sourceName': 'CLOUD_TRAIL_MGMT'
                    },
                    {
                        'sourceName': 'LAMBDA_EXECUTION'
                    },
                    {
                        'sourceName': 'S3_DATA'
                    },
                ]
            },
        ]
    )
    #
    asl_aws_log_source_response = asl_session.create_aws_log_source(
        sources=[
            {
                'accounts': [
                    account_id,
                ],
                'regions': [
                    asl_region,
                ],
                'sourceName': 'ROUTE53'
            },
            {
                'accounts': [
                    account_id,
                ],
                'regions': [
                    asl_region,
                ],
                'sourceName': 'VPC_FLOW'
            },
            {
                'accounts': [
                    account_id,
                ],
                'regions': [
                    asl_region,
                ],
                'sourceName': 'SH_FINDINGS'
            },
            {
                'accounts': [
                    account_id,
                ],
                'regions': [
                    asl_region,
                ],
                'sourceName': 'CLOUD_TRAIL_MGMT'
            },
            {
                'accounts': [
                    account_id,
                ],
                'regions': [
                    asl_region,
                ],
                'sourceName': 'LAMBDA_EXECUTION'
            },
            {
                'accounts': [
                    account_id,
                ],
                'regions': [
                    asl_region,
                ],
                'sourceName': 'S3_DATA'
            },
        ]
    )
    
    sys.stdout.write(json.dumps(security_lake_enable_result))
