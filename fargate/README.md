# Fargate deployment example

This is an example deployment using fargate, managed by terraform.

Notes:
- I needed secret values in my tfvars, as this repo is public,
- but my terraform state bucket (for example), should not be known.

- I use `shush` to encrypt/decrypt secrets (https://github.com/realestate-com-au/shush)
- There is a wrapper for descrypting tfvars files in `bin/`

Assumptions:
- CI tool will be configured to push to ECR

Design:

![High Level Design](HighLevelDesign.png)

Caveats:

Decisions:

