terraform {
  backend "s3" {
    bucket         = "capstone-state-file"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "capstone-state-file-table"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "capstone-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "vpc-${var.name}"
  }
}

resource "aws_internet_gateway" "capstone-igw" {
  vpc_id = aws_vpc.capstone-vpc.id
}

resource "aws_subnet" "public-1" {
  cidr_block              = var.subnets_cidr_public-1
  vpc_id                  = aws_vpc.capstone-vpc.id
  availability_zone       = var.azs-a
  map_public_ip_on_launch = true
  tags = {
    "Name" = "sg-public-1-${var.name}"
  }
}

resource "aws_subnet" "public-2" {
  cidr_block              = var.subnets_cidr_public-2
  vpc_id                  = aws_vpc.capstone-vpc.id
  availability_zone       = var.azs-b
  map_public_ip_on_launch = true
  tags = {
    "Name" = "sg-public-2-${var.name}"
  }
}

resource "aws_subnet" "private-1" {
  cidr_block              = var.subnets_cidr_private-1
  vpc_id                  = aws_vpc.capstone-vpc.id
  availability_zone       = var.azs-a
  map_public_ip_on_launch = true
  tags = {
    "Name" = "sg-private-1-${var.name}"
  }
}

resource "aws_subnet" "private-2" {
  cidr_block              = var.subnets_cidr_private-2
  vpc_id                  = aws_vpc.capstone-vpc.id
  availability_zone       = var.azs-b
  map_public_ip_on_launch = true
  tags = {
    "Name" = "sg-private-2-${var.name}"
  }
}

resource "aws_eip" "one" {
  vpc = true
}

resource "aws_nat_gateway" "capstone-ngw" {
  depends_on = [
    aws_eip.one
  ]
  connectivity_type = "public"
  subnet_id         = aws_subnet.public-1.id
  allocation_id     = aws_eip.one.id
}

resource "aws_route_table" "capstone-route-table-public" {
  vpc_id = aws_vpc.capstone-vpc.id
  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.capstone-igw.id
  }
  tags = {
    "Name" = "publicRouteTable"
  }
}

resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.capstone-route-table-public.id
}

resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.capstone-route-table-public.id
}

resource "aws_route_table" "capstone-route-table-private" {
  vpc_id = aws_vpc.capstone-vpc.id
  route {
    cidr_block = var.route_cidr
    gateway_id = aws_nat_gateway.capstone-ngw.id
  }
  tags = {
    "Name" = "privateRouteTable"
  }
}

resource "aws_route_table_association" "private-1" {
  depends_on = [
    aws_route_table.capstone-route-table-private
  ]
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.capstone-route-table-private.id
}

resource "aws_route_table_association" "private-2" {
  depends_on = [
    aws_route_table.capstone-route-table-private
  ]
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.capstone-route-table-private.id
}