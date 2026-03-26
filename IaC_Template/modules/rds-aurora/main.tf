############################################################
# Security Group for Aurora
############################################################
resource "aws_security_group" "aurora_sg" {
  name        = "${var.environment}-aurora-sg"
  description = "Security group for Aurora DB"
  vpc_id      = var.vpc_id

  # Allow inbound traffic ONLY from ECS app security groups
  ingress {
    description = "Allow ECS traffic"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = var.allowed_sg_ids
  }

  # Optional: Allow bastion hosts
  dynamic "ingress" {
    for_each = var.bastion_sg_ids
    content {
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
    Name        = "${var.environment}-aurora-sg"
  }
}

############################################################
# Aurora Subnet Group
############################################################
resource "aws_db_subnet_group" "aurora_subnets" {
  name        = "${var.environment}-aurora-subnet-group"
  description = "Aurora subnet group"
  subnet_ids  = var.private_subnet_ids

  tags = {
    Environment = var.environment
  }
}

############################################################
# Aurora Credentials stored in Secrets Manager
############################################################
resource "aws_secretsmanager_secret" "aurora_secret" {
  name        = "${var.environment}-aurora-credentials"
  description = "Credentials for Aurora cluster"

  tags = {
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "aurora_secret_value" {
  secret_id = aws_secretsmanager_secret.aurora_secret.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}

############################################################
# Aurora Cluster
############################################################
resource "aws_rds_cluster" "aurora" {
  cluster_identifier = "${var.environment}-aurora-cluster"
  engine             = "aurora-postgresql"
  engine_version     = var.engine_version

  database_name          = var.db_name
  master_username        = var.db_username
  master_password        = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.aurora_subnets.name
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]

  backup_retention_period = var.backup_retention
  preferred_backup_window = "02:00-04:00"

  storage_encrypted = true

  # Serverless v2 capable
  engine_mode = "provisioned"

  tags = {
    Environment = var.environment
  }
}

############################################################
# Aurora Cluster Instance (Serverless v2)
############################################################
resource "aws_rds_cluster_instance" "aurora_instance" {
  count              = var.instance_count
  identifier         = "${var.environment}-aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora.engine
  publicly_accessible = false

  tags = {
    Environment = var.environment
  }
}
