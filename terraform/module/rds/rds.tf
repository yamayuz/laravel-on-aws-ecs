resource "aws_db_subnet_group" "laravel_db_subnet_group" {
    name        = "laravel-db-subnet-group"
    description = "laravel-db-subnet-group"
    subnet_ids  = ["${var.laravel_private_subnet_1a_id}", "${var.laravel_private_subnet_1c_id}"]
}

resource "aws_rds_cluster" "laravel_rds_cluster" {
    cluster_identifier = "laravel-rds-cluster"
    db_subnet_group_name   = "${aws_db_subnet_group.laravel_db_subnet_group.name}"
    vpc_security_group_ids = ["${aws_security_group.laravel_rds_sec.id}"]
    engine = "aurora-mysql"
    port   = "3306"
    database_name   = "${var.database_name}"
    master_username = "${var.master_username}"
    master_password = "${var.master_password}"
}

resource "aws_rds_cluster_instance" "laravel_rds_cluster_instance" {
    identifier         = "laravel-rds-cluster-instance"
    cluster_identifier = "${aws_rds_cluster.laravel_rds_cluster.id}"
    engine = "aurora-mysql"
    instance_class = "db.t3.small"
}
