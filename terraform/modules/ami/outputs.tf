output "web_ami" {
  value       = aws_ami_from_instance.web.id
}

output "app_ami" {
  value       = aws_ami_from_instance.app.id
}