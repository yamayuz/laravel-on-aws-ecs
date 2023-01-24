terraform apply -target=module.aws_module.aws_ecr_repository.laravel_app_ecr_repository
terraform apply -target=module.aws_module.aws_ecr_repository.laravel_nginx_ecr_repository

docker-compose -f docker-compose.yaml build app
docker-compose -f docker-compose.yaml build nginx