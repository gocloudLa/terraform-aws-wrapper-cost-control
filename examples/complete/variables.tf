/*----------------------------------------------------------------------*/
/* Cost Control | Variable Definition                                   */
/*----------------------------------------------------------------------*/

variable "cost_control_parameters" {
  type        = any
  description = ""
  default     = {}
}

variable "cost_control_defaults" {
  description = "Map of default values which will be used for each item."
  type        = any
  default     = {}
}