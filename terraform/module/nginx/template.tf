# -----------------------------------------------
# Route53 Hosted Zone
# -----------------------------------------------
data "aws_route53_zone" "nginx_route53_zone" {
    name = "${var.domain}"
    private_zone = false
}


# -----------------------------------------------
# ecs task
# -----------------------------------------------
data "template_file" "ecs_taskdef" {
    template = file("../module/nginx/json/ecs_taskdef.json")
    vars = {
        app_log_group = aws_cloudwatch_log_group.app_log_group.name
        app_image_repository_url = aws_ecr_repository.app_ecr_repository.repository_url
        nginx_log_group = aws_cloudwatch_log_group.nginx_log_group.name
        nginx_image_repository_url = aws_ecr_repository.nginx_ecr_repository.repository_url
    }
}