variable "region" {
  description = "AWS Region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project Name (used for tagging)"
  type        = string
  default     = "roboshop"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "azs" {
  description = "Availability Zones to use"
  type        = list(string)
}
variable "ecr_repos" {
  description = "List of ECR permissions"
  type        = list(string)
}
