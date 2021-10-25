# ECS Cluster
resource "aws_ecs_cluster" ecs_cluster {
    name = "${var.service_name}-${var.environment}-cluster"
}
