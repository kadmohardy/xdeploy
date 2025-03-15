variable "ecr_name" {
  description = "The name of ECR registry"
  type        = string
  default     = null
}

variable "image_mutability" {
  description = "Provide image mutability"
  type        = string
  default     = "IMMUTABILITY"
}

variable "encrypt_type" {
  description = "Provide encrypt type here"
  type        = string
  default     = "KMS"
}

variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for main"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type    = string
  default = "useast-1a"
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ec2_image_type" {
  type    = string
  default = "ami-0c45946ade6066f3d"
}

variable "main_key_pair" {
  type    = string
  default = "main-key-pair"
}
