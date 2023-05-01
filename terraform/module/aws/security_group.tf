# -----------------------------------------------
# security group for alb
# -----------------------------------------------
resource "aws_security_group" "nginx_alb_sec" {
    name = "nginx-alb-sec"
    description = "nginx-alb-sec"
    vpc_id = "${aws_vpc.nginx_vpc.id}"
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "nginx-alb-sec"
    }
}

resource "aws_security_group_rule" "nginx_alb_sec_rule_http" {
    security_group_id = "${aws_security_group.nginx_alb_sec.id}"
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}


# -----------------------------------------------
# security group for ecs
# -----------------------------------------------
resource "aws_security_group" "nginx_ecs_sec" {
    name = "nginx-ecs-sec"
    description = "nginx-ecs-sec"
    vpc_id = "${aws_vpc.nginx_vpc.id}"
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "nginx-ecs-sec"
    }
}

resource "aws_security_group_rule" "nginx_ecs_sec_rule" {
    security_group_id = "${aws_security_group.nginx_ecs_sec.id}"
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
}


# -----------------------------------------------
# security group rule for https
# -----------------------------------------------
resource "aws_security_group_rule" "nginx_https_sec_rule" {
    security_group_id = "${aws_security_group.nginx_alb_sec.id}"
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}


# -----------------------------------------------
# security group for rds
# -----------------------------------------------
resource "aws_security_group" "rds_sec" {
    name        = "rds-sec"
    description = "rds-sec"
    vpc_id = "${aws_vpc.nginx_vpc.id}"
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "db"
    }
}

resource "aws_security_group_rule" "rds_sec_rule" {
    security_group_id = "${aws_security_group.rds_sec.id}"
    type = "ingress"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
}