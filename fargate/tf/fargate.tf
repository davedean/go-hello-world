# get current account data
data "aws_caller_identity" "current" {
}

# put the current AWS account id into a local to use
locals {
    account_id = data.aws_caller_identity.current.account_id
}

# define our task
resource "aws_ecs_task_definition" "definition" {
    family                   = "task_definition_name"
    task_role_arn            = module.iam.ecs_task_role.arn
    execution_role_arn       = module.iam.ecs_task_execution_role.arn
    network_mode             = "awsvpc"
    cpu                      = "256"
    memory                   = "1024"
    requires_compatibilities = [ "FARGATE" ]
    container_definitions = <<DEFINITION
[
  {
    "image": "${local.account_id}.dkr.ecr.eu-west-1.amazonaws.com/project:latest",
    "name": "${var.service_name}-${var.environment_short-code}-container",
    "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-region" : "${var.aws_region}",
                    "awslogs-group" : "stream-to-log-fluentd",
                    "awslogs-stream-prefix" : "${var.service_name}-${var.environment_short-code}"
                }
            },
    "secrets": [{
        "name": "secret_variable_name",
        "valueFrom": "arn:aws:ssm:region:acount:parameter/parameter_name"
    }],           
    "environment": [
            {
                "name": "HELLO_WORLD_ENVIRONMENT",
                "value": "${var.environment_short-code}"
            }
        ]
    }
  
]
DEFINITION
}
