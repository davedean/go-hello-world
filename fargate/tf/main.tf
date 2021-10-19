provider aws {
    region = "ap-southeast-2"
}

terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.0"
        }
    }

    backend "s3" {
        bucket  = "ghw-tf-state"
        key     = "tf-example"
        region  = "ap-southeast-2"
        encrypt = true
    }
}

// State bucket
resource "aws_s3_bucket" "tf_course" {
    bucket = "ghw-tf-state"
    acl = "private"
}
