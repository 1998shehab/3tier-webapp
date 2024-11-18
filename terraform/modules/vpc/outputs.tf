output "vpc_main" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_1" {
  value       = aws_subnet.public_subnet1.id
}

output "public_2" {
  value       = aws_subnet.public_subnet2.id
}

output "private_1" {
  value       = aws_subnet.private_subnet1.id
}

output "private_2" {
  value       = aws_subnet.private_subnet2.id
}

output "private_3" {
  value       = aws_subnet.private_subnet3.id
}

output "private_4" {
  value       = aws_subnet.private_subnet4.id
}


