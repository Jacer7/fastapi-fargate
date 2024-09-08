![Custom badge](https://img.shields.io/badge/Status-Active-brightgreen) ![Custom badge](https://img.shields.io/badge/Infra-AWS-orange) ![Custom badge](https://img.shields.io/badge/IAC-Terraform-blue)
![Custom badge](https://img.shields.io/badge/Container-Docker-blue)
![Custom badge](https://img.shields.io/badge/Resource-Fargate-red)

# Introduction
- Creatin of FastAPI Service
- Contanerize the application using Docker Client
- Upload the Docker Image to Docker Hub
- Create a Elastic Container Repository (ECR) with Terraform
- Upload the Docker Inage to Elastic Container Repository (ECR) by cmd line
- Create a Cluster with Terraform
- Create Task defination in Cluster, assign resource type like CPU, Memory with Terraform
- Create Service as Fargate and Fargate Spot
- Create a Capacity provider strategy, if Fargate Spot is available use it primilarily and if failed then use Fargate with Terraform
- Deploy ECR Image that was pushed from cmd line to ECS Cluster and run the task in the service we created earlier.
- hence, the final `Public IP` will be the hosted service and ready to use it.