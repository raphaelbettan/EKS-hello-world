variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "user_arn" {
  description = "ARN of the IAM user to grant access to the EKS cluster"
  type        = string
}

variable "instance_type" {
  description = "value of the instance type"
  type        = string
  default     = "t3.small"
}
