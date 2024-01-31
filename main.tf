provider "aws" {
  region = "<desired-region>"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-eks-cluster"
  subnets         = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]  # Replace with your subnet IDs
  vpc_id          = "vpc-xxxxxxxxxxxxxxxxx"  # Replace with your VPC ID
  cluster_version = "1.21"  # Specify the desired Kubernetes version

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type = "t2.small"  # You can choose a different instance type if needed

      key_name = "your-key-pair-name"  # Replace with your EC2 key pair name
    }
  }
}

resource "kubernetes_deployment" "webapp" {
  metadata {
    name = "webapp"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "webapp"
      }
    }

    template {
      metadata {
        labels = {
          app = "webapp"
        }
      }

      spec {
        containers {
          name  = "webapp"
          image = "<your-webapp-container-image>"
        }
      }
    }
  }
}

resource "kubernetes_service" "webapp" {
  metadata {
    name = "webapp"
  }

  spec {
    selector = {
      app = "webapp"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
