output "alb_to_eks_sg_id" {
  description = "ID of the security group for ALB to EKS traffic"
  value       = aws_security_group.alb_to_eks.id
}

output "alb_sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}
