# private ALB
resource "aws_security_group" "sg_alb_private" {
    name        = "lb-sg"
    description = "controls access to the Application Load Balancer (ALB)"

    ingress {
        protocol    = "tcp"
        from_port   = 80
        to_port     = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# ecs tasks from ALB
resource "aws_security_group" "ecs_tasks" {
    name        = "ecs-tasks-sg"
    description = "allow inbound access from the ALB only"

    ingress {
        protocol        = "tcp"
        from_port       = 4000
        to_port         = 4000
        cidr_blocks     = ["0.0.0.0/0"]
        security_groups = [aws_security_group.sg_alb_private.id]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}
