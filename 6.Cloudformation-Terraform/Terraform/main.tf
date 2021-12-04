provider "aws" {
  region = "us-west-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "./modules/vpc/vpc"

  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = false
  name                 = "K41"
}

module "internet_gateway" {
  source = "./modules/vpc/internet_gateway"

  vpc  = module.vpc.vpc_obj
  name = "InternetGateway"

  depends_on = [
    module.vpc
  ]
}

module "subnets" {
  source = "./modules/vpc/subnet"

  vpc = module.vpc.vpc_obj

  subnets = {
    public_a = {
      cidr_block              = "10.0.11.0/24",
      map_public_ip_on_launch = true,
      availability_zone       = data.aws_availability_zones.available.names[0],
      name                    = "PublicSubnetA",
    },
    private_a = {
      cidr_block              = "10.0.12.0/24",
      map_public_ip_on_launch = false,
      availability_zone       = data.aws_availability_zones.available.names[0],
      name                    = "PrivateSubnetA",
    },
    public_b = {
      cidr_block              = "10.0.21.0/24",
      map_public_ip_on_launch = true,
      availability_zone       = data.aws_availability_zones.available.names[1],
      name                    = "PublicSubnetB",
    },
    private_b = {
      cidr_block              = "10.0.22.0/24",
      map_public_ip_on_launch = false,
      availability_zone       = data.aws_availability_zones.available.names[1],
      name                    = "PrivateSubnetB",
    }
  }
  depends_on = [
    module.vpc
  ]
}

module "public_route_table" {
  source = "./modules/vpc/route_table"

  name                = "PublicSubnetsRouteTable"
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  vpc                 = module.vpc.vpc_obj

  subnet_ids = {
    1 = module.subnets.subnet_ids.public_a,
    2 = module.subnets.subnet_ids.public_b
  }

  depends_on = [
    module.internet_gateway,
    module.vpc,
    module.subnets
  ]
}

module "private_network_als" {
  source = "./modules/vpc/network_acl"

  name = "PrivateNetworkAcl"
  vpc  = module.vpc.vpc_obj

  subnet_ids = [
    module.subnets.subnet_ids.private_a,
    module.subnets.subnet_ids.private_b
  ]
}

module "web_security_group" {
  source = "./modules/vpc/security_group"

  vpc = module.vpc.vpc_obj

  name        = "WebSG"
  description = "Security Group for Public Subnets"

  ingresses = {
    ssh = {
      description = "Ingress rule for connect with SSH",
      from_port   = 22,
      to_port     = 22,
      protocol    = "tcp",
      cidr_blocks = ["46.56.191.1/32"],
    },
    http = {
      description     = "Ingress rule for connect with HTTP",
      from_port       = 80,
      to_port         = 80,
      protocol        = "tcp",
      security_groups = [module.load_balancer_security_group.id]
    },
    https = {
      description     = "Ingress rule for connect with HTTP",
      from_port       = 443,
      to_port         = 443,
      protocol        = "tcp",
      security_groups = [module.load_balancer_security_group.id]
    }
  }

  egresses = {
    default = {
      description = "Default Egress rule"
      from_port   = 0,
      to_port     = 0,
      protocol    = "-1",
      cidr_blocks = ["0.0.0.0/0"],
    }
  }
  depends_on = [
    module.vpc,
    module.load_balancer_security_group
  ]
}
module "load_balancer_security_group" {
  source = "./modules/vpc/security_group"

  vpc  = module.vpc.vpc_obj
  name = "LoadBalancerSG"

  description = "Security Group for LoadBalancer"
  ingresses = {
    http = {
      description = "Ingress rule for connect with HTTP",
      from_port   = 80,
      to_port     = 80,
      protocol    = "tcp",
      cidr_blocks = ["0.0.0.0/0"],
    }
  }
  egresses = {
    default = {
      description = "Default Egress rule"
      from_port   = 0,
      to_port     = 0,
      protocol    = "-1",
      cidr_blocks = ["0.0.0.0/0"],
    }
  }

  depends_on = [
    module.vpc
  ]
}

module "rds_security_group" {
  source = "./modules/vpc/security_group"

  vpc = module.vpc.vpc_obj

  name        = "RDSSG"
  description = "Security Group for RDS"

  ingresses = {
    http = {
      description     = "Ingress rule for connect",
      from_port       = 0,
      to_port         = 0,
      protocol        = "-1",
      security_groups = [module.web_security_group.id]
    },
  }

  egresses = {
    default = {
      description = "Default Egress rule"
      from_port   = 0,
      to_port     = 0,
      protocol    = "-1",
      cidr_blocks = ["0.0.0.0/0"],
    }
  }
  depends_on = [
    module.vpc,
    module.web_security_group
  ]
}

module "elastic_cache_security_group" {
  source = "./modules/vpc/security_group"

  vpc = module.vpc.vpc_obj

  name        = "ElasticCache"
  description = "Security Group for elastic cache"

  ingresses = {
    redis = {
      description     = "Ingress rule for connect to redis",
      from_port       = 6379,
      to_port         = 6379,
      protocol        = "tcp",
      security_groups = [module.web_security_group.id]
    },
    memcached = {
      description     = "Ingress rule for connect to memcached",
      from_port       = 11211,
      to_port         = 11211,
      protocol        = "tcp",
      security_groups = [module.web_security_group.id]
    }
  }

  egresses = {
    default = {
      description = "Default Egress rule"
      from_port   = 0,
      to_port     = 0,
      protocol    = "-1",
      cidr_blocks = ["0.0.0.0/0"],
    }
  }
  depends_on = [
    module.vpc,
    module.web_security_group
  ]
}

module "instances" {
  source = "./modules/ec2/instance"

  vpc             = module.vpc.vpc_obj
  security_groups = [module.web_security_group.id]

  instances = {
    nginx_a = {
      subnet_id = module.subnets.subnet_ids.public_a,
      name      = "Nginx-A",
    },
    nginx_b = {
      subnet_id = module.subnets.subnet_ids.public_b,
      name      = "Nginx-B",
    }
  }

  depends_on = [
    module.vpc,
    module.subnets,
    module.web_security_group
  ]
}

module "load_balancer" {
  source = "./modules/ec2/load_balancer"

  vpc             = module.vpc.vpc_obj
  name            = "ClassicLoadBalancer"
  security_groups = [module.load_balancer_security_group.id]

  subnets = [
    module.subnets.subnet_ids.public_a,
    module.subnets.subnet_ids.public_b
  ]

  instances = [
    module.instances.instance_ids.nginx_a,
    module.instances.instance_ids.nginx_b
  ]
  depends_on = [
    module.vpc,
    module.web_security_group,
    module.subnets,
    module.instances
  ]
}

module "rds_postgresql" {
  source = "./modules/rds/db_instance"

  vpc                    = module.vpc.vpc_obj
  availability_zone      = data.aws_availability_zones.available.names[0]
  name                   = "postgresql-rds"
  vpc_security_group_ids = [module.rds_security_group.id]
  subnet_ids = [
    module.subnets.subnet_ids.private_a,
    module.subnets.subnet_ids.private_b
  ]
}

module "elastic_chache_clusters" {
  source = "./modules/elastic_cache"

  vpc = module.vpc.vpc_obj
  security_group_ids = [
    module.elastic_cache_security_group.id
  ]
  subnets_ids = [
    module.subnets.subnet_ids.private_a
  ]

  elastic_cache_clusters = {
    redis = {
      name           = "redis-cache-cluster",
      engine         = "redis",
      engine_version = "6.x",
      port           = 6379,
    },
    memcached = {
      name           = "memcached-cache-cluster",
      engine         = "memcached",
      engine_version = "1.6.6",
      port           = 11211,
    }
  }

}

module "auto_scaling_group" {
  source = "./modules/ec2/auto_scaling_group"

  vpc  = module.vpc.vpc_obj
  name = "Nginx-ASG"

  load_balancers = [
    module.load_balancer.name
  ]

  vpc_zone_identifier = [
    module.subnets.subnet_ids.public_a,
    module.subnets.subnet_ids.public_b
  ]

  security_groups = [
    module.web_security_group.id
  ]

  scaling_policyes = {
    ingress = {
      name               = "NginxIngressSP"
      scaling_adjustment = 1
    },
    decrease = {
      name               = "NginxDecreaseSP"
      scaling_adjustment = -1
    }
  }
  depends_on = [
    module.vpc,
    module.subnets,
    module.load_balancer,
    module.web_security_group
  ]
}

module "alarms" {
  source = "./modules/cloud_watch/alarm"

  dimensions = {
    AutoScalingGroupName = module.auto_scaling_group.name
  }

  alarms = {
    CPUUtilLessThanOrEqualTo15 = {
      alarm_name          = "CPUUtilLessThanOrEqualTo15",
      comparison_operator = "LessThanOrEqualToThreshold",
      threshold           = 15,
      alarm_actions = [
        module.auto_scaling_group.scaling_policyes.decrease
      ]
    },
    CPUUtilGreaterThanOrEqualTo75 = {
      alarm_name          = "CPUUtilGreaterThanOrEqualTo75",
      comparison_operator = "GreaterThanOrEqualToThreshold",
      threshold           = 75,
      alarm_actions = [
        module.auto_scaling_group.scaling_policyes.ingress
      ]
    }
  }

  vpc = module.vpc.vpc_obj

}
