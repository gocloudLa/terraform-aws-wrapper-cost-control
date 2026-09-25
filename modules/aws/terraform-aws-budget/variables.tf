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

variable "notification" {
  description = "Object containing Budget Notifications. Can be used multiple times to define more than one budget notification."
  type        = list(any)
  default     = []
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

variable "threshold" {
  description = ""
  type        = list(number)
  default     = []
}

variable "notification_type" {
  description = ""
  type        = string
  default     = ""
}

variable "notifications" {
  description = <<-EOT
    Optional list of notification objects to define multiple notifications with
    different notification_type (e.g. ACTUAL and FORECASTED) on the same budget.
    When set (non-empty), it takes precedence over the legacy `threshold` +
    `notification_type` inputs. Each object supports:
      - threshold                  (number, required)
      - notification_type          (string, "ACTUAL" | "FORECASTED")
      - comparison_operator        (string, optional, default "GREATER_THAN")
      - threshold_type             (string, optional, default "PERCENTAGE")
      - subscriber_email_addresses (list(string), optional)
      - subscriber_sns_topic_arns  (list(string), optional)
    Leave empty to preserve the legacy behavior with no changes.
  EOT
  type        = list(any)
  default     = []
}

variable "subscriber_email_addresses" {
  description = ""
  type        = list(string)
  default     = []
}

variable "subscriber_sns_topic_arns" {
  description = ""
  type        = list(string)
  default     = []
}

variable "budget_adjustment_period" {
  description = ""
  type        = number
  default     = null
}

variable "sns_topic_arn" {
  type        = string
  description = ""
  default     = ""
}

variable "default_sns_topic_name" {
  type        = string
  description = ""
  default     = ""
}


variable "filter_expression" {
  description = "Dimension filter for the budget (key/values). Console Charge type is RECORD_TYPE, not CHARGE_TYPE. Common keys: RECORD_TYPE, SERVICE, LINKED_ACCOUNT, REGION."
  type        = map(any)
  default     = {}
}

variable "metrics" {
  description = "Leave unset. The module always counts the budget in USD."
  type        = list(string)
  default     = []
}

variable "threshold_type" {
  description = "What kind of threshold is defined. Can be PERCENTAGE OR ABSOLUTE_VALUE."
  type        = string
  default     = ""
}