resource "aws_ecr_repository" ecr_repository {
    name                 = var.service_name
}

resource "aws_ecr_lifecycle_policy" repo-policy {
    repository = aws_ecr_repository.ecr_repository.name

    policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep image deployed with tag latest",
            "selection": {
              "tagStatus": "tagged",
              "tagPrefixList": ["latest"],
              "countType": "imageCountMoreThan",
              "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Keep X older images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 5
            },
        "action": {
            "type": "expire"
        }
        }
    ]
}
EOF
}
