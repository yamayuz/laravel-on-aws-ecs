# -----------------------------------------------
# ecs task execution role
# -----------------------------------------------
resource "aws_iam_role" "ecs_task_execution_role" {
    name = "ecs-task-execution-role"
        assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "",
          "Effect": "Allow",
          "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
EOF
}

resource "aws_iam_role_policy" "ecs_task_execution_role_policy" {
    role = aws_iam_role.ecs_task_execution_role.name
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters",
                "secretsmanager:GetSecretValue",
                "kms:Decrypt"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
    role = aws_iam_role.ecs_task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# -----------------------------------------------
# ecs task role
# -----------------------------------------------
resource "aws_iam_role" "ecs_task_role" {
    name = "ecs-task-role"
        assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "",
          "Effect": "Allow",
          "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
EOF
}

data "aws_iam_policy_document" "ecs_exec_doc" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_exec_policy" {
  name   = "AmazonECSExecPolicy"
  policy = data.aws_iam_policy_document.ecs_exec_doc.json
}

resource "aws_iam_role_policy_attachment" "sec_task_attachement" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_exec_policy.arn
}