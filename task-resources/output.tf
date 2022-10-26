output "vpc-id" {
  value = aws_vpc.capstone-vpc.id
}

output "igw" {
  value = aws_internet_gateway.capstone-igw.id
}

output "subnet-public-1" {
  value = aws_subnet.public-1.id
}

output "subnet-public-2" {
  value = aws_subnet.public-2.id
}

output "subnet-private-1" {
  value = aws_subnet.private-1.id
}

output "subnet-private-2" {
  value = aws_subnet.private-2.id
}
