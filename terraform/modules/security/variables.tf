variable "project_name" {
  description = "Name used to identify project resources"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where security groups will be created"
  type        = string
}

variable "container_port" {
  description = "Port on which the application container listens"
  type        = number
  default     = 3000
}
