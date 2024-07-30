module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = [var.instance_type]
  }

  eks_managed_node_groups = {
    workers = {
      min_size     = 2
      max_size     = 2
      desired_size = 2

      instance_types = [var.instance_type]
    }
  }

  create_cloudwatch_log_group = true

  manage_aws_auth_configmap = true
  aws_auth_users = [
    {
      userarn  = var.user_arn
      username = split("/", var.user_arn)[1]
      groups   = ["system:masters"]
    }
  ]
}
