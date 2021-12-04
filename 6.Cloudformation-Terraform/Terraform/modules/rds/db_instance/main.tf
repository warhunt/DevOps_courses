resource "aws_db_instance" "postgresql" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "12.5"
  instance_class         = "db.t2.micro"
  identifier             = var.name
  username               = "wolly"
  password               = data.aws_ssm_parameter.my_postgresql_password.value
  skip_final_snapshot    = true
  publicly_accessible    = false
  port                   = 5432
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = var.vpc_security_group_ids
  depends_on = [
    aws_db_subnet_group.default,
    aws_ssm_parameter.postgresql_password
  ]
}

resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "${var.vpc.vpc_name}-RDSSubnetGroup"
  }
}

resource "random_string" "postgresql_password" {
  length           = 12
  special          = true
  override_special = "!#$&"
}

resource "aws_ssm_parameter" "postgresql_password" {
  name        = "/prod/postgresql"
  description = "Postgresql password"
  type        = "SecureString"
  value       = random_string.postgresql_password.result
  depends_on = [
    random_string.postgresql_password
  ]
}

data "aws_ssm_parameter" "my_postgresql_password" {
  name = "/prod/postgresql"

  depends_on = [
    aws_ssm_parameter.postgresql_password
  ]
}
