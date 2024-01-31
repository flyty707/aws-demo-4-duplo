output "cluster_name" {
  value = module.eks.cluster_id
}

output "webapp_service_url" {
  value = kubernetes_service.webapp.status[0].load_balancer.ingress[0].hostname
}
