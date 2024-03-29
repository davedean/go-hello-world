# Set up locals
locals {
    # split the vpc cidr (leaves half our space free for the future)
    subnet-block_public  = cidrsubnet(var.vpc_cidr-block, var.vpc_subnet-bits, 0)
    subnet-block_private = cidrsubnet(var.vpc_cidr-block, var.vpc_subnet-bits, 1)

    # split the subnet-block cidr (var->local here for readability)
    subnet-bits = var.subnet-bits
}

# Get availability zone data
data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "service_vpc" {
    cidr_block = var.vpc_cidr-block
    enable_dns_hostnames = true

    tags = { Name = "${var.service_name} VPC - ${var.environment_short-code}" }
}

### Public Subnets and related infra

# Public Subnets
resource "aws_subnet" "public_subnet" {

    count                   = length(data.aws_availability_zones.available.names)
    vpc_id                  = aws_vpc.service_vpc.id
    cidr_block              = cidrsubnet(local.subnet-block_public, local.subnet-bits, count.index)
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true

    tags = { Name = "${var.service_name} Public Subnet - ${var.environment_short-code}" }
}

# Internet GW
resource "aws_internet_gateway" "internet-gw" {
    vpc_id = aws_vpc.service_vpc.id

    tags = { Name = "${var.service_name} IGW - ${var.environment_short-code}" }
}


# Routing table for public subnets
resource "aws_route_table" "route-table_public" {
    vpc_id = aws_vpc.service_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet-gw.id
    }

    tags = { Name = "${var.service_name} Public RT - ${var.environment_short-code}" }
}

# Assoc route table with public subnets
resource "aws_route_table_association" "route-assoc_public" {
    count          = length(data.aws_availability_zones.available.names)
    subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
    route_table_id = aws_route_table.route-table_public.id
}

### End Public Subnets and related infra


### Private Subnets and related infra

# Private Subnets
resource "aws_subnet" "private_subnet" {
    count                   = length(data.aws_availability_zones.available.names)
    vpc_id                  = aws_vpc.service_vpc.id
    cidr_block              = cidrsubnet(local.subnet-block_private, local.subnet-bits, count.index)
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = false

    tags = { Name = "${var.service_name} Private Subnet - ${var.environment_short-code}" }
}

# Route table for Private Subnets
resource "aws_route_table" "route-table_private" {
    vpc_id = aws_vpc.service_vpc.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.private_nat-gw.id
    }

    tags = { Name = "${var.service_name} Private RT - ${var.environment_short-code}" }
}

# Assoc route table with private subnets
resource "aws_route_table_association" "private_route" {
    count          = length(data.aws_availability_zones.available.names)
    subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
    route_table_id = aws_route_table.route-table_private.id
}

# NAT gateway requires an EIP
resource "aws_eip" "private_nat-gw_eip" {
    vpc = true

    tags = { Name = "${var.service_name} Private NAT GW EIP - ${var.environment_short-code}"  }
}

# NAT Gateway
resource "aws_nat_gateway" "private_nat-gw" {
    allocation_id = aws_eip.private_nat-gw_eip.id
    subnet_id     = element(aws_subnet.public_subnet.*.id, 1)
    depends_on    = [ aws_internet_gateway.internet-gw ]

    tags = { Name = "${var.service_name} Private NAT GW - ${var.environment_short-code}"  }
}

### End Private Subnets and related infra
