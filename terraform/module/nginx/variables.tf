variable "domain" {
    description = "Route53で管理しているドメイン名"
    type = string
    default = "mysite-webapp.com"
}

variable "app" {
    default = {
        db_host = ""
        db_port = ""
        db_database = ""
        db_username = ""
        db_password = ""
        app_env = ""
    }
}