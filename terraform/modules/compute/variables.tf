variable "project_name" {
  description = "Name used to identify project resources"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where ECS tasks will run"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "container_port" {
  description = "Port on which the application container listens"
  type        = number
  default     = 3000
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}
variable "alb_security_group_id" {
  description = "Security group ID for the application load balancer"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the load balancer and target group will run"
  type        = string
}
