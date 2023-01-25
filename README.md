https://y-ohgi.com/introduction-terraform/handson/ecs/


terraform apply -target=module.nginx.aws_ecr_repository.nginx_ecr_repository
terraform apply -target=module.nginx.aws_ecr_repository.app_ecr_repository

docker-compose -f docker-compose.yml build --no-cache nginx
docker-compose -f docker-compose.yml build --no-cache app





