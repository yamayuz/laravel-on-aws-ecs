# -----------------------------------------------
# acm
# -----------------------------------------------
resource "aws_acm_certificate" "nginx_acm_cer" {
    domain_name = "${var.domain}"
    validation_method = "DNS"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_acm_certificate_validation" "nginx_acm_cer_val" {
    certificate_arn = "${aws_acm_certificate.nginx_acm_cer.arn}"
    validation_record_fqdns = [for record in aws_route53_record.nginx_route53_record_val : record.fqdn]
}


# -----------------------------------------------
# Route53
# -----------------------------------------------
resource "aws_route53_record" "nginx_route53_record_val" {
    depends_on = ["aws_acm_certificate.nginx_acm_cer"]
    zone_id = "${data.aws_route53_zone.nginx_route53_zone.id}"
    ttl = 60

    for_each = {
        for dvo in aws_acm_certificate.nginx_acm_cer.domain_validation_options : dvo.domain_name => {
            name = dvo.resource_record_name
            type = dvo.resource_record_type
            records = dvo.resource_record_value
        }
    }
    name = each.value.name
    type = each.value.type
    records = [each.value.records]
}

resource "aws_route53_record" "nginx_route53_record_main" {
    type = "A"
    name = "${var.domain}"
    zone_id = "${data.aws_route53_zone.nginx_route53_zone.id}"
    alias {
        name = "${aws_alb.nginx_alb.dns_name}"
        zone_id = "${aws_alb.nginx_alb.zone_id}"
        evaluate_target_health = true
    }
}