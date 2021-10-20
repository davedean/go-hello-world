# Fargate deployment example

This is an example deployment using fargate, managed by terraform.

Notes:
- I needed secret values in my tfvars, so I use `shush` to encrypt/decrypt secrets
- There is a wrapper for descrypting tfvars files in `bin/`

Assumptions:
- CI tool will be configured to push to ECR

Design:

![High Level Design](HighLevelDesign.png)

Caveats:

Decisions:

