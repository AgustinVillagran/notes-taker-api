variable "bucket_name" {
  description = "The name of the S3 bucket. Must be globally unique."
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "The bucket_name value must be a valid DNS 1123 subdomain."
  }
}

variable "table_name" {
  description = "The name of the DynamoDB table. Must be unique in this region."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{1,255}$", var.table_name))
    error_message = "The table_name value must be a valid identifier."
  }
}
