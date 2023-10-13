output "alb_hostname" {
  value = aws_alb.main.dns_name
  description = "The domain name of the load balancer"
}
