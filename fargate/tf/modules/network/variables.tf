variable "vpc_cidr-block" {
    default = "10.0.0.0/16"
}

variable "environment" {
}

variable "environment_short-code" {
}

variable "service_name" {
}

variable "vpc_subnet-bits" {
    default = "4"
}

variable "subnet-bits" {
    default = "4"
}

variable "aws_region" {
    default = "ap-southeast-2"
}
