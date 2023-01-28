resource "aws_ssm_parameter" "db_host" {
    name = "/db_host"
    type = "String"
    value = "${aws_db_instance.rds_instance.endpoint}"
}

resource "aws_ssm_parameter" "db_port" {
    name = "/db_port"
    type = "String"
    value = var.app.db_port
}

resource "aws_ssm_parameter" "db_database" {
    name = "/db_database"
    type = "String"
    value = var.app.db_database
}

resource "aws_ssm_parameter" "db_username" {
    name = "/db_username"
    type = "String"
    value = var.app.db_username
}

resource "aws_ssm_parameter" "db_password" {
    name = "/db_password"
    type = "String"
    value = var.app.db_password
}

resource "aws_ssm_parameter" "app_env" {
    name = "/app_env"
    type = "String"
    value = var.app.app_env
}