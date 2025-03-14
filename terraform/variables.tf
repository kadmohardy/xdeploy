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
