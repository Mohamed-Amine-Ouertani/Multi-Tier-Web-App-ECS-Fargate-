address= "http://127.0.0.1:8200" # The address of the vault provider in the provider.tf file

backend = "aws" #backend attribute for the vault_aws_access_credentials in the provider.tf file

role = "terraform-role" #role attribute for the vault_aws_access_credentials in the provider.tf file

region = "eu-north-1"
# NOTE: EC2p5 (instance_type) instances does only exist in those regions [Europe (Stockholm) — eu-north-1, Asia Pacific (Tokyo) — ap-northeast-1, US West (Oregon) — us-west-2, US East (Ohio) — us-east-2, US East (N. Virginia) — us-east-1]
# NOTE: EC2pe5 (instance_type) instances does only exists in the "US East (Ohio) — us-east-2" region

environment = "Production" # Environment on witch we are deploying the Infrastructure.

vpc_cidr_block = "10.0.0.0/16" # The CIDR block for your VPC

vpc_name = "main-vpc"  # The name of your VPC

availability_zones = ["eu-north-1a", "eu-north-1b"] # changing the number of AZ will result in an error 

S3-expiration_days= 365 # Delete objects after one year

aurora_db_name = "value" #The Database name

aurora_db_username = "value" #The Database username

aurora_db_password = "value" #The Database password
