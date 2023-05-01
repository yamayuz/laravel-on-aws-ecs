# laravel-on-aws-ecs
Webアプリケーションをnginx + Laravel on ECS + RDSの環境で動かす。

## 構成
![test](https://user-images.githubusercontent.com/99404423/215111589-b841a4d7-2574-480c-a7f5-d5d78ac83490.png)

## Setup (on AWS)
1. terraform/terraform.tfvarsを用意して、DB接続情報を記載する
2. docker/nginx/default.confを書き換え
```
local : fastcgi_pass app:9000;
aws : fastcgi_pass localhost:9000;
```

3. ECRにnginxとlaravelのリポジトリを作成
```
cd terraform/prod
terraform init
terraform apply -target=module.aws.aws_ecr_repository.nginx_ecr_repository
terraform apply -target=module.aws.aws_ecr_repository.app_ecr_repository
```

4. docker imageを作成し、タグをつける
```
cd ../..
docker-compose -f docker-compose.yml build --no-cache nginx
docker-compose -f docker-compose.yml build --no-cache app
docker tag laravel-on-aws-ecs_nginx:latest [AWS_ACCOUNT_ID].dkr.ecr.ap-northeast-1.amazonaws.com/nginx:latest
docker tag laravel-on-aws-ecs_app:latest [AWS_ACCOUNT_ID].dkr.ecr.ap-northeast-1.amazonaws.com/laravel:latest
```

5. AWS CLI認証し、docker imageをecrへプッシュ
```
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin [AWS_ACCOUNT_ID].dkr.ecr.ap-northeast-1.amazonaws.com
docker push [AWS_ACCOUNT_ID].dkr.ecr.ap-northeast-1.amazonaws.com/nginx:latest
docker push [AWS_ACCOUNT_ID].dkr.ecr.ap-northeast-1.amazonaws.com/laravel:latest
```

6. make other AWS resources
```
cd terraform/prod
terraform plan
terraform apply
```

7. migratation
ECS Execでappコンテナに接続しmigrationを実行する
```
aws ecs execute-command --task=[タスクID] --interactive --cluster=myapp --container=app --command /bin/sh
php artisan migrate
```
※Notes: don't forget [terraform destroy]

## Reference source
* [Terraformで構築するAWS](https://y-ohgi.com/introduction-terraform/handson/ecs/)
* [ECS Exec を有効化する手順](https://qiita.com/tonluqclml/items/ef20541dbefb46e6a193)
