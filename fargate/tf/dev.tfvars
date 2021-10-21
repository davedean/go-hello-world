# Environment name
environment             = "Development"
environment_short-code  = "Dev"

# VPC details
vpc_cidr-block          = "10.8.0.0/16"
# first two octets of VPC CIDR, used to calculate subnets - could use split() 
# but it makes things unreadable quickly splitting and joining.
vpc_cidr-block_fragment = "10.8"
