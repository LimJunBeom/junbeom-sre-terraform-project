variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"  # US East (N. Virginia)
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "monitoring-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "node_group_name" {
  description = "Node group name"
  type        = string
  default     = "monitoring-nodes"
}

variable "node_group_instance_types" {
  description = "Node group instance types"
  type        = list(string)
  default     = ["t3.micro"]  # Free tier instance
}

variable "node_group_desired_size" {
  description = "Node group desired size"
  type        = number
  default     = 1  # Minimize for free tier
}

variable "node_group_max_size" {
  description = "Node group maximum size"
  type        = number
  default     = 1  # Minimize for free tier
}

variable "node_group_min_size" {
  description = "Node group minimum size"
  type        = number
  default     = 1  # Keep minimum for free tier
}

variable "node_group_disk_size" {
  description = "Node group disk size (GB)"
  type        = number
  default     = 20
}
