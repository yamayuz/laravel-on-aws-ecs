resource "aws_ecr_repository" "nginx_ecr_repository" {
    name = "nginx"
}

resource "aws_ecr_repository" "app_ecr_repository" {
    name = "laravel"
}