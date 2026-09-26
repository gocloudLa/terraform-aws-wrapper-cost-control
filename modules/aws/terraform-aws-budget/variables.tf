variable "budget_type" {
  description = "Whether this budget tracks monetary cost or usage."
  type        = string
  default     = ""
}

variable "limit_amount" {
  description = "The amount of cost or usage being measured for a budget."
  type        = number
}

variable "limit_unit" {
  description = "The unit of measurement used for the budget forecast, actual spend, or budget threshold, such as dollars or GB."
  type        = string
  default     = ""
}

variable "time_unit" {
  description = "The length of time until a budget resets the actual and forecasted spend."
  type        = string
  default     = ""
}

variable "auto_adjust_data" {
  description = "Object containing AutoAdjustData to determine the budget amount for auto-adjusting budgets."
  type        = any
  default     = {}
}

variable "name" {
  description = "The name of a budget. Unique within accounts."
  type        = string
  default     = ""
}

variable "planned_limit" {
  description = "Object containing Planned Budget Limits. Can be used multiple times to plan more than one budget limit."
  type        = list(any)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "notifications" {
  description = "Notification objects for the budget."
  type        = any
  default     = []
}

variable "default_sns_topic_name" {
  type        = string
  description = "SNS topic name used when a notification has no subscriber topic ARNs."
  default     = ""
}

variable "filter_expression" {
  description = "Dimension filter that scopes which charges the budget measures."
  type        = map(any)
  default     = {}
}

variable "metrics" {
  description = "Cost metrics included in the budget calculation."
  type        = list(string)
  default     = []
}
