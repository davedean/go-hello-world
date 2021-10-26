output "service_vpc" {
    value = aws_vpc.service_vpc
    description = "the vpc for this service"
}

output "private_subnets" {
    value = aws_subnet.private_subnet.*
    description = "the private subnets for this service"
}

output "public_subnets" {
    value = aws_subnet.public_subnet.*
    description = "the public subnets for this service"
}
