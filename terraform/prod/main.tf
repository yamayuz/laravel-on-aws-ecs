variable "app" {}

module "nginx" {
    source = "../module/nginx"
    app = var.app
}
