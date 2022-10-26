variable "vpc_cidr" {
  default = "10.5.0.0/16"
}

variable "route_cidr" {
  default = "0.0.0.0/0"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "azs-a" {
  default = "us-east-1a"
}

variable "azs-b" {
  default = "us-east-1b"
}

variable "subnets_cidr_public-1" {
  default = "10.5.1.0/24"
}

variable "subnets_cidr_public-2" {
  default = "10.5.2.0/24"
}

variable "subnets_cidr_private-1" {
  default = "10.5.5.0/24"
}

variable "subnets_cidr_private-2" {
  default = "10.5.6.0/24"
}

variable "name" {
  default = "capstone"
}