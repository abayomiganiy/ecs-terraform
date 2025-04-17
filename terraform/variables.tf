variable "aws_region" {
  default = "us-west-2"
}

variable "app_name" {
  default = "my-ecs-app"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ecr_url" {
  type        = string
  description = "ECR image URL"
  default = "971422675840.dkr.ecr.us-west-2.amazonaws.com/my-ecs-app"
}
