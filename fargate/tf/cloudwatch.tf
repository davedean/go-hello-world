# log group
resource "aws_cloudwatch_log_group" "log_group" {
    name = "${var.service_name}-${var.environment_short-code}"
}

