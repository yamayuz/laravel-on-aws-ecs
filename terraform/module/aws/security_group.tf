# -----------------------------------------------
# security group for alb
# -----------------------------------------------
resource "aws_security_group" "laravel_alb_sec" {
    name = "laravel-alb-sec"
    description = "laravel-alb-sec"
    vpc_id = "${aws_vpc.laravel_vpc.id}"
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "laravel-alb-sec"
    }
}

resource "aws_security_group_rule" "laravel_alb_sec_rule_http" {
    security_group_id = "${aws_security_group.laravel_alb_sec.id}"
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}


# -----------------------------------------------
# security group for ecs
# -----------------------------------------------
resource "aws_security_group" "laravel_ecs_sec" {
    name = "laravel-ecs-sec"
    description = "laravel-ecs-sec"
    vpc_id = "${aws_vpc.laravel_vpc.id}"
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "laravel-ecs-sec"
    }
}

resource "aws_security_group_rule" "laravel_ecs_sec_rule" {
    security_group_id = "${aws_security_group.laravel_ecs_sec.id}"
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
}


# -----------------------------------------------
# security group rule for https
# -----------------------------------------------
resource "aws_security_group_rule" "laravel_https_sec_rule" {
    security_group_id = "${aws_security_group.laravel_alb_sec.id}"
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}