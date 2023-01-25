https://y-ohgi.com/introduction-terraform/handson/ecs/


terraform apply -target=module.nginx.aws_ecr_repository.nginx_ecr_repository
terraform apply -target=module.nginx.aws_ecr_repository.app_ecr_repository

docker-compose -f docker-compose.yml build --no-cache nginx
docker-compose -f docker-compose.yml build --no-cache app

docker tag laravel-on-aws-ecs-2_nginx:latest 848162895353.dkr.ecr.ap-northeast-1.amazonaws.com/nginx:latest
docker tag laravel-on-aws-ecs-2_app:latest 848162895353.dkr.ecr.ap-northeast-1.amazonaws.com/laravel:latest




