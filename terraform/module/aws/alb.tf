resource "aws_alb" "laravel_alb" {
    name = "laravel-load-balancer"
    security_groups = ["${aws_security_group.laravel_alb_sec.id}"]
    subnets = ["${aws_subnet.laravel_public_subnet_1a.id}", "${aws_subnet.laravel_public_subnet_1c.id}"]
}

resource "aws_alb_target_group" "laravel_alb_target_group" {
    name = "laravel-target-group"
    vpc_id = "${aws_vpc.laravel_vpc.id}"
    port = 80
    protocol = "HTTP"
    target_type = "ip"
    health_check {
        port = 80
        path = "/"
    }
}

resource "aws_alb_listener" "laravel_alb_listener" {
    port = "80"
    protocol = "HTTP"
    load_balancer_arn = "${aws_alb.laravel_alb.arn}"
    default_action {
        type = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            status_code = "200"
            message_body = "ok"
        }
    }
}

resource "aws_alb_listener_rule" "laravel_alb_listener_rule" {
    listener_arn = "${aws_alb_listener.laravel_alb_listener.arn}"
    action {
        type = "forward"
        target_group_arn = "${aws_alb_target_group.laravel_alb_target_group.arn}"
    }
    condition {
        path_pattern {
            values = ["*"]
        }
    }
}

# -----------------------------------------------
# alb listener for https
# -----------------------------------------------
resource "aws_alb_listener" "laravel_alb_listener_https" {
    load_balancer_arn = "${aws_alb.laravel_alb.arn}"
    certificate_arn = "${aws_acm_certificate.laravel_acm_cer.arn}"
    port = "443"
    protocol = "HTTPS"
    default_action {
        type = "forward"
        target_group_arn = "${aws_alb_target_group.laravel_alb_target_group.arn}"
    }
}

resource "aws_alb_listener_rule" "laravel_alb_listener_rule_thhps" {
    listener_arn = "${aws_alb_listener.laravel_alb_listener.arn}"
    priority = 99
    action {
        type = "redirect"
        redirect {
            port = "443"
            protocol = "HTTPS"
            status_code = "HTTP_301"
        }
    }
    condition {
        host_header {
            values = ["${var.domain}"]
        }        
    }
}