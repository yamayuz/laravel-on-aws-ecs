resource "aws_security_group" "laravel_rds_sec" {
    name        = "laravel-rds-sec"
    description = "laravel-rds-sec"
    vpc_id = "${var.vpc_id}"
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "laravel-db"
    }
}

resource "aws_security_group_rule" "laravel_rds_sec_rule" {
    security_group_id = "${aws_security_group.laravel_rds_sec.id}"
    type = "ingress"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
}