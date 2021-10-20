output "s3_bucket_id" {
  description = "ID of the terraform backend s3 bucket"
  value       = aws_s3_bucket.tf_state_bucket.id
}

