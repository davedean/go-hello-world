# get current account data
data "aws_caller_identity" "current" {
}

# put the current AWS account id into a local to use
locals {
    account_id = data.aws_caller_identity.current.account_id
}

resource "aws_ecs_service" "ecs_service" {
    name            = "${var.service_name}-${var.environment_short-code}"
    cluster         = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.definition.arn
    desired_count   = 1
    iam_role        = aws_iam_role.ecs_task_role.arn
    depends_on      = [ aws_iam_role.ecs_task_role ]
    launch_type     = "FARGATE"

    load_balancer {
        target_group_arn = aws_lb_target_group.lb-tg_private.arn
        container_name   = "${var.service_name}"
        container_port   = 8080
    }

}

# define our task
resource "aws_ecs_task_definition" "definition" {
    family                   = "task_definition_name"
    task_role_arn            = aws_iam_role.ecs_task_role.arn
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    network_mode             = "awsvpc"
    cpu                      = "256"
    memory                   = "1024"
    requires_compatibilities = [ "FARGATE" ]
    container_definitions = <<DEFINITION
[
  {
    "image": "${local.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.service_name}:latest",
    "name": "${var.service_name}-${var.environment_short-code}-container",
    "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-region" : "${var.aws_region}",
                    "awslogs-group" : "stream-to-log-fluentd",
                    "awslogs-stream-prefix" : "${var.service_name}-${var.environment_short-code}"
                }
            },
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
