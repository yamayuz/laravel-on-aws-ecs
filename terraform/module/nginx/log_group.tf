resource "aws_cloudwatch_log_group" "nginx_log_group" {
    name = "nginx"
}

resource "aws_cloudwatch_log_group" "app_log_group" {
    name = "app"
}