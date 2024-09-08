# Output the default VPC ID
output "default_vpc_id" {
  description = "ID of the default VPC"
  value       = data.aws_vpc.default.id
}

# Output the subnet details to verify
output "selected_subnet_details" {
  description = "Details of the selected subnet"
  value       = data.aws_subnet.selected_subnet
}


# Output the subnet ID
output "selected_subnet_cidr" {
  description = "The ID of the selected subnet"
  value       = data.aws_subnet.selected_subnet.cidr_block
}


output "ecr_repository_url" {
  description = "The URL of the ECR repository for pulling the container image"
  value       = aws_ecr_repository.ElasticContainerRegistry.repository_url
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.ECS_Cluster.name
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.fastapi_ecs_service.name
}

output "ecs_task_family" {
  description = "The family name of the ECS task definition"
  value       = aws_ecs_task_definition.fargate_task.family
}

output "ecs_task_definition_arn" {
  description = "The ARN of the ECS task definition"
  value       = aws_ecs_task_definition.fargate_task.arn
}


output "ecs_security_group_id" {
  description = "The security group ID used by the ECS service"
  value       = aws_security_group.ecs_web_access_sg.id
}


