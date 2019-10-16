## networking
module "networking" {
  source                = "./modules/networking"
  env = var.env
  vpc_name = var.vpc_name
  az_names = var.az_names
  allowed_bastion_ip_cidr_list = var.allowed_bastion_ip_cidr_list
  bastion_ami = var.bastion_ami
  ssh_public_key = var.ssh_public_key
}


## DB Aurora Serverless MySQL
module "db" {
  source        = "./modules/db"
  project_name  = var.project_name
  env           = var.env

  subnets                         = module.networking.public_subnets
  vpc_id                          = module.networking.vpc_id
  allowed_security_groups         = module.networking.list_sg_allowed_to_connect_to_db_sg
  vpc_security_group_ids          = module.networking.list_db_sg
}