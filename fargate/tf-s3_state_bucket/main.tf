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

/*
    backend "s3" {
        bucket  = "ghw-tf-state"
        key     = "s3_bootstrap"
        region  = "ap-southeast-2"
        encrypt = true
    }
*/

}

// State bucket
resource "aws_s3_bucket" "tf_state_bucket" {
    // Globally unique and hard to guess name
    // Doing this so that the bucket name is not in code
    bucket = "fg-tf-state-${random_string.bucket_suffix.result}"
    acl = "private"
    
    tags = {
        Purpose = "TF Backend Bucket"
    }
}

// Random string for bucket name suffix
resource "random_string" "bucket_suffix" {
  length           = 24
#  override_special = "/@£$"
  upper   = false
  lower   = true
  number  = true
  special = false
}
