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
        // note: bucket = is not specified here, and is provided by backend.tfvars
        key     = "fg-tf-main"

        region  = "ap-southeast-2"
        encrypt = true

        // nb: in a production setting you should use DynamoDB to manage locking
        // but there's exactly one user of this repo, so not doing it here.
    }
}
