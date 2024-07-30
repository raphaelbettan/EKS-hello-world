variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/24"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.0.0/27", "10.0.0.32/27"]
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.0.64/27", "10.0.0.96/27"]
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "jifiti-eks-cluster"
}

variable "user_arn" {
  description = "ARN of the IAM user to grant access to the EKS cluster"
  type        = string
  default     = "arn:aws:iam::518571960807:user/Sandbox-user-1A"
}