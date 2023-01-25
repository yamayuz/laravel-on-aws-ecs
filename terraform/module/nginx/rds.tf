resource "aws_db_subnet_group" "rds_subnet_group" {
    name        = "rds-subnet-group"
    subnet_ids  = ["${aws_subnet.nginx_private_subnet_1a.id}", "${aws_subnet.nginx_private_subnet_1c.id}"]
    tags = {
        Name = "db_rds"
    }
}

resource "aws_db_instance" "rds_instance" {
    identifier           = "rds-instance"
    allocated_storage    = 20
    storage_type         = "gp2"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    db_name              = "app_database"
    username             = "user"
    password             = "password"
    vpc_security_group_ids  = ["${aws_security_group.rds_sec.id}"]
    db_subnet_group_name = "${aws_db_subnet_group.rds_subnet_group.name}"
    skip_final_snapshot = true
}