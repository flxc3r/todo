data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.17.0"

  name = "${var.vpc_name}-${var.env}"

  cidr = "10.0.0.0/16"

  azs             = var.az_names
  //private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = false

  # tags on all resources of module
  tags = {
    environment = var.env
    billing_category = "cross-project"
  }

  # tags for vpc only
  vpc_tags = {
    Name = var.vpc_name
  }
}