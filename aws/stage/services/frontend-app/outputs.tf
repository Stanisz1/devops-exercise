output "alb_hostname" {
  value = aws_alb.main.dns_name
  description = "The domain name of the load balancer"
}

output "redis_cluster_id" {
  value = aws_memorydb_cluster.redis_cluster.id
  description = "The Redis cluster"
}

output "cluster_endpoint_address" {
  description = "DNS hostname of the cluster configuration endpoint"
  value       = aws_memorydb_cluster.redis_cluster.cluster_endpoint[0].address
}

output "cluster_endpoint_port" {
  description = "Port number that the cluster configuration endpoint is listening on"
  value       = aws_memorydb_cluster.redis_cluster.cluster_endpoint[0].port
}

# output "redis_endpoint" {
#   value = aws_elasticache_cluster.redis.configuration_endpoint
# }
