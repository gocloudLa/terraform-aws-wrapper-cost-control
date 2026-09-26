/*----------------------------------------------------------------------*/
/* Cost Control | Variable Definition                                   */
/*----------------------------------------------------------------------*/

variable "cost_control_parameters" {
  type        = any
  description = "Budgets and Cost Anomaly Detection settings for this account."
  default     = {}
}

variable "cost_control_defaults" {
  type        = any
  description = "Default values merged into each entry of cost_control_parameters."
  default     = {}
}