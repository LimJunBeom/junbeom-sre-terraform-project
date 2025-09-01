# VPC and networking resources
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway     = false  # Disable NAT Gateway to avoid charges
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  # EKS tags
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  tags = {
    Environment = "dev"
    Project     = "eks-monitoring"
  }
}

# EKS cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets  # Use public subnets to avoid NAT Gateway

  eks_managed_node_groups = {
    "${var.node_group_name}" = {
      desired_size    = var.node_group_desired_size
      max_size        = var.node_group_max_size
      min_size        = var.node_group_min_size
      instance_types  = var.node_group_instance_types
      capacity_type   = "ON_DEMAND"  # For free tier

      # Node group configuration
      disk_size = var.node_group_disk_size

      # Labels and tags
      labels = {
        Environment = "dev"
        Project     = "monitoring"
      }

      tags = {
        ExtraTag = "eks-node-group"
      }
    }
  }

  # Cluster security group
  cluster_security_group_additional_rules = {
    ingress_nodes_443 = {
      description                = "Node groups to cluster API"
      protocol                  = "tcp"
      port                      = 443
      type                      = "ingress"
      source_node_security_group = true
    }
  }

  # Cluster tags
  tags = {
    Environment = "dev"
    Project     = "eks-monitoring"
  }
}

# IAM roles and policies are handled by the EKS module automatically
