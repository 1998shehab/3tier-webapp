output "web_lb_sg" {
  value       = aws_security_group.web-alb-security-group.id
}

output "web_sg" {
  value       = aws_security_group.webserver-security-group.id
}

output "alb_dns_name" {
  value       = aws_lb.web-load-balancer.dns_name
}


