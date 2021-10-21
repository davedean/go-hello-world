# Initialize availability zone data from AWS
data "aws_availability_zones" "available" {}

resource "aws_vpc" "fg_tf_vpc" {
    cidr_block = var.vpc_cidr-block
    enable_dns_hostnames = true

    tags = { Name = "Fargate Example VPC - ${var.environment_short-code}" }
}

locals {
    # complicated way to obtain first two octets of VPC 
    vpc_cidr-block_fragment =  join(".", [ split(".", var.vpc_cidr-block)[0], split(".", var.vpc_cidr-block)[1] ] )
}

### Public Subnets and related infra

# Public Subnets
resource "aws_subnet" "public_subnet" {

    count                   = length(data.aws_availability_zones.available.names)
    vpc_id                  = aws_vpc.fg_tf_vpc.id
    cidr_block              = "${local.vpc_cidr-block_fragment}.${0+count.index}.0/24"
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true

    tags = { Name = "Fargate Public Subnet - ${var.environment_short-code}" }
}

# Internet GW
resource "aws_internet_gateway" "internet-gw" {
    vpc_id = aws_vpc.fg_tf_vpc.id

    tags = { Name = "Fargate Example IGW - ${var.environment_short-code}" }
}


# Routing table for public subnets
resource "aws_route_table" "route-table_public" {
    vpc_id = aws_vpc.fg_tf_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet-gw.id
    }

    tags = { Name = "Fargate Public RT - ${var.environment_short-code}" }
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
    vpc_id                  = aws_vpc.fg_tf_vpc.id
    #cidr_block              = "10.0.${40+count.index}.0/24"
    cidr_block              = "${local.vpc_cidr-block_fragment}.${10+count.index}.0/24"
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = false

    tags = { Name = "Fargate Private Subnet - ${var.environment_short-code}" }
}

# Route table for Private Subnets
resource "aws_route_table" "route-table_private" {
    vpc_id = aws_vpc.fg_tf_vpc.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.private_nat-gw.id
    }

    tags = { Name = "Fargate Private RT - ${var.environment_short-code}" }
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

    tags = { Name = "Fargate Private NAT GW EIP - ${var.environment_short-code}"  }
}

# NAT Gateway
resource "aws_nat_gateway" "private_nat-gw" {
    allocation_id = aws_eip.private_nat-gw_eip.id
    subnet_id     = element(aws_subnet.private_subnet.*.id, 1)
    depends_on    = [ aws_internet_gateway.internet-gw ]

    tags = { Name = "Fargate Private NAT GW - ${var.environment_short-code}"  }
}

### End Private Subnets and related infra
