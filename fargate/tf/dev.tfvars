# service name
service_name            = "go-hello-world"

# Environment name
environment             = "Development"
environment_short-code  = "Dev"

# VPC details
vpc_cidr-block          = "10.8.0.0/16"
vpc_subnet-splits       = "4" # split the vpc cidr into 4
subnet-splits           = "4" # split the useable cidrs into 4 for subnets per AZ
