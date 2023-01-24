module "aws_prod_module" {
    source = "../module/prod"
}

module "aws_module" {
    source = "../module/aws"
}

module "rds" {
    source = "../module/rds"

    vpc_id = "${module.aws_module.vpc_id}"
    laravel_private_subnet_1a_id = "${module.aws_module.laravel_private_subnet_1a_id}"
    laravel_private_subnet_1c_id = "${module.aws_module.laravel_private_subnet_1c_id}" 
    database_name   = "mydatabase"
    master_username = "myusername"
    master_password = "mypassword"
}