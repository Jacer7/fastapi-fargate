resource "aws_ecr_repository" "ElasticContainerRegistry" {
  name                 = "ecr-fastapi-service"
  image_tag_mutability = "MUTABLE" # if the same tag is pushed again, it will be overwritten

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(
    local.common_tags,
    {
      Name = ""
    },
  )
}