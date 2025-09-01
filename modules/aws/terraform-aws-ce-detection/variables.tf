variable "enable" {
  description = ""
  type        = bool
  default     = false
}

variable "name" {
  description = "The name of the monitor and suscription."
  type        = string
  default     = ""
}

variable "monitor_type" {
  description = "The possible type values."
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

### subscription variables

variable "monitor_arn_list" {
  description = "A list of cost anomaly monitors."
  type        = list(string)
  default     = []
}

variable "type" {
  description = "The type of subscription."
  type        = string
  default     = ""
}

variable "address" {
  description = "The address of the subscriber. If type is SNS, this will be the arn of the sns topic. If type is EMAIL, this will be the destination email address."
  type        = string
  default     = ""
}

variable "threshold_absolute" {
  description = ""
  type        = string
  default     = null
}

variable "threshold_percentage" {
  description = ""
  type        = string
  default     = null
}

variable "default_sns_topic_name" {
  type        = string
  description = ""
  default     = ""
}