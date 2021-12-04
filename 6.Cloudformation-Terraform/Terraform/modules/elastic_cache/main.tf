resource "aws_elasticache_cluster" "example" {
  for_each = var.elastic_cache_clusters


  cluster_id         = each.value.name
  engine             = each.value.engine
  node_type          = "cache.t3.micro"
  num_cache_nodes    = 1
  port               = each.value.port
  engine_version     = each.value.engine_version
  subnet_group_name  = aws_elasticache_subnet_group.elastic_cache_subnet_group.name
  security_group_ids = var.security_group_ids
  tags = {
    Name = "${var.vpc.vpc_name}-${each.value.name}"
  }

  depends_on = [
    aws_elasticache_subnet_group.elastic_cache_subnet_group
  ]
}

resource "aws_elasticache_subnet_group" "elastic_cache_subnet_group" {
  name       = "default-cache-subnet-group"
  subnet_ids = var.subnets_ids
}
