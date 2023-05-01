variable "app" {}

module "aws" {
    source = "../module/aws"
    app = var.app
}
