resource "aws_security_group" "sg" {
  name        = "${var.name}-${var.env}-sg"
  description = "${var.name}-${var.env}-sg"
  vpc_id      = var.vpc_id

  # access these for only app subnets
  ingress {
    description = "redis"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.allow_db_cidr
  }

  # outside access
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-${var.env}-sg" })
}

resource "aws_elasticache_subnet_group" "subnet-group" {
  name       = "${var.name}-${var.env}-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = merge(var.tags, { Name = "${var.name}-${var.env}-subnet-group" })
}

resource "aws_elasticache_parameter_group" "param-group" {
  name   = "${var.name}-${var.env}-param-group"
  family = "redis2x"
  tags   = merge(var.tags, { Name = "${var.name}-${var.env}-param-group" })
}

resource "aws_elasticache_replication_group" "replication-group" {
  replication_group_id       = "${var.name}-${var.env}-replication-group"
  description                = "${var.name}-${var.env}-replication-group"
  engine                     = "redis"
  engine_version             = var.engine_version
  subnet_group_name          = aws_elasticache_subnet_group.subnet-group.name
  security_group_ids         = [aws_security_group.sg.id]
  node_type                  = var.node_type
  port                       = 6379
  parameter_group_name       = aws_elasticache_parameter_group.param-group.name
  automatic_failover_enabled = true
  num_node_groups            = var.num_node_groups
  replicas_per_node_group    = var.replicas_per_node_group
  tags                       = merge(var.tags, { Name = "${var.name}-${var.env}-replication-group" })
}