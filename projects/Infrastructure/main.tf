module "vpc" {
  source = "./modules/vpc"

  vpc_name     = var.vpc_name
  cidr_block   = var.vpc_cidr
  cluster_name = var.cluster_name

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name

  instance_types = var.instance_types
  capacity_type  = var.capacity_type
  disk_size      = var.disk_size

  min_size     = var.min_size
  desired_size = var.desired_size
  max_size     = var.max_size

  cluster_subnet_ids = module.vpc.all_subnet_ids
  node_subnet_ids    = module.vpc.private_subnet_ids

  depends_on = [module.vpc]
}

module "ecr" {
  source = "./modules/ecr"

  repositories = var.repositories
}


data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  alias = "eks"

  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}


module "argocd" {
  source = "./modules/argocd"

  providers = {
    kubernetes = kubernetes.eks
    helm       = helm.eks
  }

  depends_on = [module.eks]
}

