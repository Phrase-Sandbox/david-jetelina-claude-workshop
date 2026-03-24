variable "noncurrent_version_expiration_days" {
  description = "Number of days after which noncurrent object versions expire. Only relevant when versioning is enabled."
  type        = number
  default     = 90

  validation {
    condition     = var.noncurrent_version_expiration_days > 0
    error_message = "Noncurrent version expiration days must be positive."
  }
}

variable "force_destroy" {
  description = "Allow destruction of non-empty bucket. Run terraform destroy to clean up."
  type        = bool
  default     = false
}

variable "abort_incomplete_multipart_upload_days" {
  type    = number
  default = 7
}
