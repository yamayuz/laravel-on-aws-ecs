variable "domain" {
    description = "Route53で管理しているドメイン名"
    type = string
    default = "mysite-webapp.com"
}

variable db_host {
    default = "rds-instance.cvnmh5fxogui.ap-northeast-1.rds.amazonaws.com"
}

variable db_port {
    default = "3306"
}
variable db_database {
    default = "app_database"
}
variable db_username {
    default = "user"
}
variable db_password {
    default = "password"
}

variable app_env {
    default = "production"
}