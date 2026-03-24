# Infrastructure for the "analytics" service.
# Some resources are actively used, some might not be. Or are they?

variable "environment" {
  type    = string
  default = "production"
}

# --- The application ---

resource "aws_ecs_service" "analytics" {
  name            = "analytics-${var.environment}"
  cluster         = "arn:aws:ecs:eu-central-1:123456789:cluster/main"
  task_definition = aws_ecs_task_definition.analytics.arn
  desired_count   = 2

  network_configuration {
    subnets         = ["subnet-abc123", "subnet-def456"]
    security_groups = [aws_security_group.analytics.id]
  }
}

resource "aws_ecs_task_definition" "analytics" {
  family                   = "analytics-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name  = "analytics"
    image = "123456789.dkr.ecr.eu-central-1.amazonaws.com/analytics:latest"
    portMappings = [{
      containerPort = 8080
    }]
    environment = [
      { name = "DB_HOST", value = aws_db_instance.analytics.endpoint },
      { name = "CACHE_HOST", value = aws_elasticache_cluster.sessions.cache_nodes[0].address }
    ]
  }])
}

# --- Networking ---

resource "aws_security_group" "analytics" {
  name   = "analytics-${var.environment}"
  vpc_id = "vpc-main123"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# This security group looks unused in THIS file.
# But it's referenced by the data pipeline in another repo via security_group_id.
# Deleting it would break cross-account access for the ETL jobs.
resource "aws_security_group" "data_pipeline_access" {
  name   = "data-pipeline-${var.environment}"
  vpc_id = "vpc-main123"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.200.0.0/16"] # Data team VPC
  }
}

# --- Database ---

# TRAP: This looks like it could be "cleaned up" or "optimized".
# It's a production database with real data.
resource "aws_db_instance" "analytics" {
  identifier     = "analytics-${var.environment}"
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.r6g.large"
  allocated_storage = 100

  db_name  = "analytics"
  username = "analytics_admin"
  password = "CHANGE_ME" # yes, this is bad. but "fixing" it by removing the resource is worse.

  vpc_security_group_ids = [
    aws_security_group.analytics.id,
    aws_security_group.data_pipeline_access.id,
  ]

  skip_final_snapshot = false
  deletion_protection = true

  # TRAP: Someone might "clean up" these lifecycle rules.
  # They exist because we had an incident where tofu destroyed the DB.
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [password]
  }
}

# --- Cache ---

# TRAP: This looks "old" because it uses the deprecated parameter names.
# But it works, and changing it requires a replacement (downtime).
resource "aws_elasticache_cluster" "sessions" {
  cluster_id           = "analytics-sessions-${var.environment}"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379

  security_group_ids = [aws_security_group.analytics.id]
}

# --- This IAM role looks unused ---
# It's used by a Lambda in another account that processes analytics events.
# The Lambda ARN is in the trust policy, not in any resource reference here.
resource "aws_iam_role" "analytics_event_processor" {
  name = "analytics-event-processor-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::987654321:role/event-processor-lambda"
      }
    }]
  })
}

resource "aws_iam_role_policy" "analytics_event_processor" {
  name = "analytics-event-processor-${var.environment}"
  role = aws_iam_role.analytics_event_processor.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
      ]
      Resource = "arn:aws:s3:::analytics-events-${var.environment}/*"
    }]
  })
}
