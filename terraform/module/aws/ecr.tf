resource "aws_ecr_repository" "laravel_app_ecr_repository" {
    name = "laravel/app"
}

resource "aws_ecr_repository" "laravel_nginx_ecr_repository" {
    name = "laravel/nginx"
}
