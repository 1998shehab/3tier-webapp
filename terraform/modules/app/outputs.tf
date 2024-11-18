output "app_lb_sg" {
  value       = aws_security_group.app-alb-security-group.id
}

output "app_sg" {
  value       = aws_security_group.app-security-group.id
}

output "app_dnsname" {
  value       = aws_lb.application-load-balancer.dns_name
}