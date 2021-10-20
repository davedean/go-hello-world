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

}

// KMS key so we can shush secrets
resource "aws_kms_key" "shush_key" {
    description = "Shush Key"
}

// Alias so it's easy to refer to
resource "aws_kms_alias" "shush_key_alias" {
  name          = "alias/shush"
  target_key_id = aws_kms_key.shush_key.key_id
}

// State bucket for tf
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
