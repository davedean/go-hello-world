# Terraform S3 State Bucket

If we include the Terraform S3 State Bucket in the "main" terraform, it would be destroyed when we run a `terraform destroy`. This would createproblems, as we'd no longer be able to store state.

So I'm keeping the S3 bucket creation separate from the main terraform.

I may bring other "shared" components in here, but for now, this is just for bootstrapping terraform itself.
