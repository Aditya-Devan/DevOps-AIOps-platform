variable "region" {
  description = "The name of the region"
  type        = string
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Value"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets for internet-facing load balancers"
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  description = "Private subnets for EKS worker nodes"
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
}

variable "cluster_name" {
  description = "The name of the Kubernetes Cluster"
  type        = string
}

variable "node_group_name" {
  type        = string
  description = "EKS node group name"
}

variable "instance_types" {
  type        = list(string)
  description = "Instance types for worker nodes (t3.medium, t3.large)"
}

variable "capacity_type" {
  type        = string
  description = "ON_DEMAND or SPOT"
}

variable "desired_size" {
  type        = number
  description = "Desired number of worker nodes"
}

variable "min_size" {
  type        = number
  description = "Minimum number of  worker nodes"
}

variable "max_size" {
  type        = number
  description = "Maximum number of worker nodes"
}

variable "disk_size" {
  type = number
}

variable "repositories" {
  type = list(string)
}