variable "enable" {
  description = "Create the Cost Anomaly monitor and subscription."
  type        = bool
  default     = false
}

variable "name" {
  description = "Name of the monitor and subscription."
  type        = string
  default     = ""
}

variable "monitor_type" {
  description = "Monitor type. DIMENSIONAL or CUSTOM."
  type        = string
  default     = ""
}

variable "monitor_dimension" {
  description = "The dimensions to evaluate (Required, if monitor_type is DIMENSIONAL)."
  type        = string
  default     = ""
}

variable "monitor_specification" {
  description = "A valid JSON representation for the Expression object (Required, if monitor_type is CUSTOM)."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "type" {
  description = "The type of subscription."
  type        = string
  default     = ""
}

variable "address" {
  description = "SNS topic ARN or email address for the subscriber."
  type        = string
  default     = ""
}

variable "threshold_absolute" {
  description = "Minimum unexpected spend in USD that raises an anomaly alert."
  type        = string
  default     = null
}

variable "threshold_percentage" {
  description = "Minimum unexpected spend, as a percent above expected, that raises an anomaly alert."
  type        = string
  default     = null
}

variable "default_sns_topic_name" {
  type        = string
  description = "SNS topic name used when address is empty."
  default     = ""
}