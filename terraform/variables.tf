variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"  # US East (N. Virginia)
}

variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
  default     = "monitoring-cluster"
}

variable "cluster_version" {
  description = "Kubernetes 버전"
  type        = string
  default     = "1.28"
}

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "node_group_name" {
  description = "노드 그룹 이름"
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
  default     = 2
}

variable "node_group_max_size" {
  description = "Node group maximum size"
  type        = number
  default     = 3
}

variable "node_group_min_size" {
  description = "Node group minimum size"
  type        = number
  default     = 1
}

variable "node_group_disk_size" {
  description = "Node group disk size (GB)"
  type        = number
  default     = 20
}
