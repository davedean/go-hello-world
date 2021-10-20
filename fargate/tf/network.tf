# Initialize availability zone data from AWS
data "aws_availability_zones" "available" {}

resource "aws_vpc" "fg_tf_vpc" {
    cidr_block = "10.0.0.0/16" 
    enable_dns_hostnames = true

    tags = {
        Name = "Fargate Example VPC"
    }
}

### Public Subnets and related infra

# Public Subnets
resource "aws_subnet" "public_subnet" {
    count                   = length(data.aws_availability_zones.available.names)
    vpc_id                  = aws_vpc.fg_tf_vpc.id
    cidr_block              = "10.0.${0+count.index}.0/24"
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
}

# Internet GW
resource "aws_internet_gateway" "internet-gw" {
    vpc_id = aws_vpc.fg_tf_vpc.id
}


# Routing table for public subnets
resource "aws_route_table" "route-table_public" {
    vpc_id = aws_vpc.fg_tf_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet-gw.id
    }
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
    cidr_block              = "10.0.${40+count.index}.0/24"
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = false
}

# Route table for Private Subnets
resource "aws_route_table" "route-table_private" {
    vpc_id = aws_vpc.fg_tf_vpc.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.private_nat-gw.id
    }
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
}

# NAT Gateway
resource "aws_nat_gateway" "private_nat-gw" {
    allocation_id = aws_eip.private_nat-gw_eip.id
    subnet_id     = element(aws_subnet.private_subnet.*.id, 1)
    depends_on    = [ aws_internet_gateway.internet-gw ]
}

### End Private Subnets and related infra

