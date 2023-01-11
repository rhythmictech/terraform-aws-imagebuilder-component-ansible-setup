output "component_arn" {
  description = "ARN of the EC2 Image Builder Component"
  value       = aws_imagebuilder_component.this.arn
}
