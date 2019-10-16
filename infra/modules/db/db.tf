module "aurora" {
  source                = "terraform-aws-modules/rds-aurora/aws"
  version               = "~> 2.0"
  name                  = "${var.project_name}-db-${var.env}"
  engine                = "aurora"
  engine_mode           = "serverless"
  replica_scale_enabled = false
  replica_count         = 0

  backtrack_window = 10 # ignored in serverless

  subnets                         = var.subnets
  vpc_id                          = var.vpc_id
  allowed_security_groups         = var.allowed_security_groups
  vpc_security_group_ids          = var.vpc_security_group_ids

  monitoring_interval             = 60
  instance_type                   = "db.r4.large"
  apply_immediately               = true
  skip_final_snapshot             = true
  storage_encrypted               = true
  db_parameter_group_name         = aws_db_parameter_group.aurora_db_postgres96_parameter_group.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_postgres96_parameter_group.id

  scaling_configuration = {
    auto_pause               = true
    max_capacity             = 1
    min_capacity             = 1
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }

  tags                  = {
    project_name = var.project_name
    environment = var.env
    billing_category = "project-specific"
  }
}

resource "aws_db_parameter_group" "aurora_db_postgres96_parameter_group" {
  name        = "${var.project_name}-${var.env}-aurora56-parameter-group"
  family      = "aurora5.6"
  description = "${var.project_name}-${var.env}-aurora56-parameter-group"
  tags                  = {
    project_name = var.project_name
    environment = var.env
    billing_category = "project-specific"
  }
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_postgres96_parameter_group" {
  name        = "${var.project_name}-${var.env}-aurora56-cluster-parameter-group"
  family      = "aurora5.6"
  description = "${var.project_name}-${var.env}-aurora56-cluster-parameter-group"
  tags                  = {
    project_name = var.project_name
    environment = var.env
    billing_category = "project-specific"
  }
}