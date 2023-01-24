# -----------------------------------------------
# Route53 Hosted Zone
# -----------------------------------------------
data "aws_route53_zone" "laravel_route53_zone" {
    name = "${var.domain}"
    private_zone = false
}