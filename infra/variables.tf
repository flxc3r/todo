variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "az_names" {
  type    = list(string)
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "allowed_bastion_ip_cidr_list" {
  type = list(string)
}

variable "bastion_ami" {
  type = string
}

variable "ssh_public_key" {
  type = string
}