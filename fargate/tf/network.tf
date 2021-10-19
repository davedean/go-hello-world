resource "aws_ecs_cluster" "ghw-cluster" {
    name = "ghw-cluster"
}

resource "aws_vpc" "aws-vpc" { 
    cidr_block = "10.0.0.0/16" 
    enable_dns_hostnames = true
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
}
