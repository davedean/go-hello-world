resource "aws_lb" "alb_private" {
    name               = "alb"
    subnets            = aws_subnet.private_subnet.*.id
    load_balancer_type = "application"
    security_groups    = [aws_security_group.sg_alb_private.id]
}

resource "aws_lb_listener" "https-fwd_private" {
    load_balancer_arn = aws_lb.alb_private.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        target_group_arn = aws_lb_target_group.lb-tg_private.arn
        type = "forward"
     }

}

resource "aws_lb_target_group" "lb-tg_private" {
    name        = "alb-tg"
    port        = 8080
    protocol    = "HTTP"
    vpc_id      = aws_vpc.fg_tf_vpc.id
    target_type = "ip"

    health_check {
        healthy_threshold   = "3"
        interval            = "90"
        protocol            = "HTTP"
        matcher             = "200"
        timeout             = "10"
        path                = "/health"
        unhealthy_threshold = "2"
    }
}
