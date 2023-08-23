#!/usr/bin/env python3
import sys
import subprocess
import argparse

def install(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

try:
    import boto3
except:
    install("boto3")
    
finally:    
    import boto3

from botocore.exceptions import ClientError

# logger = logging.getLogger(__name__)


def get_session(**kwargs):
    session = boto3.session.Session()
    return session.client(kwargs['allowed_services'])

# arguments parser
parser = argparse.ArgumentParser(description='Argparse Tutorial')
parser.add_argument('--delegation_id',type=int, required=True, help="Security Lake delegation target accound id")
args    = parser.parse_args()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    account_id = get_session(allowed_services = "sts").get_caller_identity().get('Account')
    print(f"Security Lake delegation from {account_id} to {args.delegation_id}")
    
    asl_session = get_session(allowed_services = "securitylake")
    
    response = asl_session.register_data_lake_delegated_administrator(
        accountId = f"{args.delegation_id}"
    )
    
    print(response)