# output the loadbalancer hostname
output "kubernetes_svc_loadbalancer_hostname" {
  description = "Service type Loadbalancer host name"
  value       = kubernetes_service.hello-kubernetes-svc.status.0.load_balancer.0.ingress.0.hostname
}

