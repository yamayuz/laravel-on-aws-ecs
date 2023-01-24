# -----------------------------------------------
# VPC
# -----------------------------------------------
resource "aws_vpc" "laravel_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "laravel-vpc"
    }
}

resource "aws_internet_gateway" "laravel_igw" {
    vpc_id = "${aws_vpc.laravel_vpc.id}"
    tags = {
        Name = "laravel-igw"
    }
}


# -----------------------------------------------
# public subnet
# -----------------------------------------------
resource "aws_subnet" "laravel_public_subnet_1a" {
    vpc_id = "${aws_vpc.laravel_vpc.id}"
    availability_zone = "ap-northeast-1a"
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "laravel-public-subnet-1a"
    }
}

resource "aws_subnet" "laravel_public_subnet_1c" {
    vpc_id = "${aws_vpc.laravel_vpc.id}"
    availability_zone = "ap-northeast-1c"
    cidr_block = "10.0.2.0/24"
    tags = {
        Name = "laravel-public-subnet-1c"
    }
}

resource "aws_eip" "laravel_eip_1a" {
    vpc = true
    tags = {
        Name = "laravel-eip-1a"
    }
}

resource "aws_nat_gateway" "laravel_nat_1a" {
    subnet_id = "${aws_subnet.laravel_public_subnet_1a.id}"
    allocation_id = "${aws_eip.laravel_eip_1a.id}"
    tags = {
        Name = "laravel-nat-1a"
    }
}


# -----------------------------------------------
# private subnet
# -----------------------------------------------
resource "aws_subnet" "laravel_private_subnet_1a" {
    vpc_id = "${aws_vpc.laravel_vpc.id}"
    availability_zone = "ap-northeast-1a"
    cidr_block = "10.0.10.0/24"
    tags = {
        Name = "laravel-private-subnet-1a"
    }
}

resource "aws_subnet" "laravel_private_subnet_1c" {
    vpc_id = "${aws_vpc.laravel_vpc.id}"
    availability_zone = "ap-northeast-1c"
    cidr_block = "10.0.20.0/24"
    tags = {
        Name = "laravel-private-subnet-1c"
    }
}


# -----------------------------------------------
# route (Internet Gateway - Public Subnet)
# -----------------------------------------------
resource "aws_route_table" "laravel_public_table" {
    vpc_id = "${aws_vpc.laravel_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.laravel_igw.id}"
    }
    tags = {
        Name = "laravel-public-table"
    }
}

resource "aws_route_table_association" "public_association_1a" {
    subnet_id      = "${aws_subnet.laravel_public_subnet_1a.id}"
    route_table_id = "${aws_route_table.laravel_public_table.id}"
}

resource "aws_route_table_association" "public_association_1c" {
    subnet_id      = "${aws_subnet.laravel_public_subnet_1c.id}"
    route_table_id = "${aws_route_table.laravel_public_table.id}"
}


# -----------------------------------------------
# route (Nat Gateway - Private Subnet)
# -----------------------------------------------
resource "aws_route_table" "laravel_private_table_1a" {
    vpc_id = "${aws_vpc.laravel_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_nat_gateway.laravel_nat_1a.id}"
    }
    tags = {
        Name = "laravel-private-table-1a"
    }
}

resource "aws_route_table_association" "private_association_1a" {
    subnet_id      = "${aws_subnet.laravel_private_subnet_1a.id}"
    route_table_id = "${aws_route_table.laravel_private_table_1a.id}"
}


# -----------------------------------------------
# output
# -----------------------------------------------
output "vpc_id" {
    value = aws_vpc.laravel_vpc.id
}

output "laravel_private_subnet_1a_id" {
    value = aws_subnet.laravel_private_subnet_1a.id
}

output "laravel_private_subnet_1c_id" {
    value = aws_subnet.laravel_private_subnet_1c.id
}