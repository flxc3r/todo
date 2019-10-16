variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "allowed_security_groups" {
  type = list(string)
}

variable "vpc_security_group_ids" {
  type = list(string)
}

