resource "aws_ecs_cluster" "laravel_ecs_cluster" {
    name = "laravel"
}

resource "aws_ecs_service" "laravel_ecs_service" {
    name = "laravel"
    depends_on = ["aws_alb_listener_rule.laravel_alb_listener_rule"]
    cluster = "${aws_ecs_cluster.laravel_ecs_cluster.name}"
    launch_type = "FARGATE"
    desired_count = "1"
    task_definition = "${aws_ecs_task_definition.laravel_ecs_task.arn}"
    health_check_grace_period_seconds = 3600
    network_configuration {
        subnets  = ["${aws_subnet.laravel_private_subnet_1a.id}"]
        security_groups = ["${aws_security_group.laravel_ecs_sec.id}"]
    }
    load_balancer {
        target_group_arn = "${aws_alb_target_group.laravel_alb_target_group.arn}"
        container_name   = "laravel"
        container_port   = "80"
    }
}

resource "aws_ecs_task_definition" "laravel_ecs_task" {
    family = "laravel"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"
    network_mode = "awsvpc"
    container_definitions = <<EOL
    [
        {
            "name": "laravel",
            "image": "nginx:1.18",
            "portMappings": [
                {
                    "containerPort": 80,
                    "hostPort": 80
                }
            ]
        }
    ]
    EOL
}