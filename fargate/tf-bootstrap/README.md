# Terraform S3 State Bucket

If we include the Terraform S3 State Bucket in the "main" terraform, it would be destroyed when we run a `terraform destroy`. This would createproblems, as we'd no longer be able to store state.

So I'm keeping the S3 bucket creation separate from the main terraform.

Additionally, in order to securely store secrets such as the s3 backend, we need to be able to `shush`. In order to `shush` we need a KMS key, so that is also created here.
