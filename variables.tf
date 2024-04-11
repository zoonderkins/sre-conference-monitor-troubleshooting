locals {
  project_name = "monitor-troubleshooting"
}

variable "owner" {
  description = "The owner of the resources"
  default     = "AlvinLin"
}

variable "region" {
  default     = "ap-northeast-1"
  description = "aws region"
  type        = string
}

variable "project" {
  default     = "prism"
  description = "name of the project"
  type        = string
}

variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}


variable "cloudwatch_log_retention_days" {
  default     = 30
  description = "days of cloudwatch log retention"
  type        = number
}