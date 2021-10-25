provider aws {
    region = "ap-southeast-2"

    default_tags {
        tags = {
            Environment = "${var.environment}"
            Service     = "${var.service_name}"
        }
    }
}

terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.0"
        }
    }

    backend "s3" {
        # note: bucket = is not specified here, and is provided by backend.tfvars
        key     = "fg-tf-main"

        region  = "ap-southeast-2"
        encrypt = true

        # use dynamodb locking
        dynamodb_table = "fg-tf-main_tf-lock"
    }
}
