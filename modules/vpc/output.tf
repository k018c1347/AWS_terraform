output "vpc_id" {
  value = aws_vpc.minami_vpc.id
}
output "vpc_cidr" {
  value = aws_vpc.minami_vpc.cidr_block
}

output "public_subnet_id" {
  value = aws_subnet.public[*].id
}

output "private_subnet_id" {
  value = aws_subnet.private[*].id
}