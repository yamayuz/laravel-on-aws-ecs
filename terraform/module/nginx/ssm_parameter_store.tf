resource "aws_ssm_parameter" "db_host" {
    name = "/db_host"
    type = "String"
    value = var.db_host
}

resource "aws_ssm_parameter" "db_port" {
    name = "/db_port"
    type = "String"
    value = var.db_port
}

resource "aws_ssm_parameter" "db_database" {
    name = "/db_database"
    type = "String"
    value = var.db_database
}

resource "aws_ssm_parameter" "db_username" {
    name = "/db_username"
    type = "String"
    value = var.db_username
}

resource "aws_ssm_parameter" "db_password" {
    name = "/db_password"
    type = "String"
    value = var.db_password
}