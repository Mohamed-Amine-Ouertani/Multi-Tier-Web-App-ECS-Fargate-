# VPC Module
module "vpc" {
  source      = "./modules/vpc"
  cidr_block  = var.vpc_cidr_block
  name        = var.vpc_name
}

# Subnet Module
module "subnet" {
  source            = "./modules/subnet"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.vpc_cidr_block
  availability_zones = var.availability_zones
}

# NAT Gateway Module
module "nat_gw" {
  source             = "./modules/nat-gw"
  public_subnet_ids  = module.subnet.public_subnet_ids
  availability_zones = var.availability_zones
}

# The Router Module
module "router" {
  source = "./modules/router"
  availability_zones= var.availability_zones
  vpc_id = module.vpc.vpc_id
  igw_id = module.vpc.igw_id
  nat_gateway_ids = module.nat_gw.nat_gateway_ids
  public_subnet_ids = module.subnet.public_subnet_ids
  private_subnet_ids_a = module.subnet.private_subnet_ids_a
  private_subnet_ids_b = module.subnet.private_subnet_ids_b
}

# The Security Group Module
module "security-groups" {
  source = "./modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

#The Load Balancer Module
module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  alb_security_groups_id = module.security-groups.alb_sg_id
  public_subnet_ids = module.subnet.public_subnet_ids
}

module "s3" {
  source = "./modules/s3"
  environment = var.environment
  expiration_days = var.S3-expiration_days
  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
}

module "cloudfront" {
  source = "./modules/cloudfront"
  environment = var.environment
  s3_domain_name = module.s3.s3_bucket_domain_name

}

module "api_gateway" {
  source = "./modules/api-gateway"
  environment = var.environment
  method = "ANY"
  alb_dns_name = module.alb.alb_dns_name
  alb_arn = module.alb.alb_arn
}
module "ecr1" {
  source = "./modules/ecr"
  environment = var.environment
  
}
module "ecs-cluster" {
  source = "./modules/ecs-cluster"
  environment = var.environment
}

module "ecs-task1" {
  source = "./modules/ecs-task"
  region = var.region
  environment = var.environment
  service_name = module.ecs-service1.service_name
  cpu = 1
  memory = 2
  container_port = 443
  ecr_repository_url = module.ecr1.repository_url
  image_tag = "latest"
}

module "ecs-service1" {
  source = "./modules/ecs-service"
  environment = var.environment
  service_name = ""
  vpc_id= module.vpc.vpc_id
  cluster_name = module.ecs-cluster.cluster_name
  task_definition_arn = module.ecs-task1.task_definition_arn
  private_subnet_ids = module.subnet.private_subnet_ids_a
  container_port = module.ecs-task1.container_port
}

module "CloudWatch" {
  source = "./modules/cloudwatch"
  environment = var.environment
  service_name = module.ecs-service1
  rds_cluster_id = ""
}

module "rds-aurora" {
  source = "./modules/rds-aurora"
  environment = var.environment
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.subnet.private_subnet_ids_b
  allowed_sg_ids = module.security-groups.app_sg_id
  db_name = var.aurora_db_name
  db_username = var.aurora_db_username
  db_password = var.aurora_db_password
}