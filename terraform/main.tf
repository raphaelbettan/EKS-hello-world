module "vpc" {
  source = "./modules/vpc"

  region          = var.region
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  user_arn        = var.user_arn
}

module "security_groups" {
  source = "./modules/security_groups"

  vpc_id = module.vpc.vpc_id
}

module "lb_controller" {
  source = "./modules/lb_controller"

  cluster_name = module.eks.cluster_name
  vpc_id       = module.vpc.vpc_id
}

# module "hello_world_app" {
#   source = "./modules/hello_world_app"

#   depends_on = [module.lb_controller]
# }

module "monitoring" {
  source = "./modules/monitoring"

  depends_on = [module.eks]
}
