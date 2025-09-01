module "budget" {
  source = "./modules/aws/terraform-aws-budget"

  for_each = try(var.cost_control_parameters.budget, {})

  name                       = "${local.common_name}-${each.key}"
  default_sns_topic_name     = try(each.value.default_sns_topic_name, var.cost_control_defaults.budget.default_sns_topic_name, local.default_sns_topic_name)
  budget_type                = try(each.value.budget_type, var.cost_control_defaults.budget.budget_type, "COST")
  limit_amount               = try(each.value.limit_amount, var.cost_control_defaults.budget.limit_amount, null)
  limit_unit                 = try(each.value.limit_unit, var.cost_control_defaults.budget.limit_unit, "USD")
  time_unit                  = try(each.value.time_unit, var.cost_control_defaults.budget.time_unit, null)
  auto_adjust_data           = try(each.value.auto_adjust_data, var.cost_control_defaults.budget.auto_adjust_data, {})
  cost_types                 = try(each.value.cost_types, var.cost_control_defaults.budget.cost_types, {})
  threshold                  = try(each.value.threshold, var.cost_control_defaults.budget.threshold, [])
  notification_type          = try(each.value.notification_type, var.cost_control_defaults.budget.notification_type, each.value.time_unit == "DAILY" ? "ACTUAL" : "FORECASTED")
  subscriber_email_addresses = try(each.value.subscriber_email_addresses, var.cost_control_defaults.budget.subscriber_email_addresses, [])
  subscriber_sns_topic_arns  = try(each.value.subscriber_sns_topic_arns, var.cost_control_defaults.budget.subscriber_sns_topic_arns, [])
  planned_limit              = try(each.value.planned_limit, var.cost_control_defaults.budget.planned_limit, [])

  tags = local.common_tags
}

module "cost_anomaly" {
  source = "./modules/aws/terraform-aws-ce-detection"
  enable = try(var.cost_control_parameters.cost_anomaly.enable, false)

  name                   = "${local.common_name}-cost-anomaly"
  default_sns_topic_name = try(var.cost_control_parameters.default_sns_topic_name, var.cost_control_defaults.budget.default_sns_topic_name, local.default_sns_topic_name)
  monitor_type           = try(var.cost_control_parameters.cost_anomaly.monitor_type, var.cost_control_defaults.cost_anomaly.monitor_type, "DIMENSIONAL")
  monitor_dimension      = try(var.cost_control_parameters.cost_anomaly.monitor_dimension, var.cost_control_defaults.cost_anomaly.monitor_dimension, "SERVICE")
  monitor_specification  = try(var.cost_control_parameters.cost_anomaly.monitor_specification, var.cost_control_defaults.cost_anomaly.monitor_specification, null)
  type                   = try(var.cost_control_parameters.cost_anomaly.type, var.cost_control_defaults.cost_anomaly.type, "SNS")
  address                = try(var.cost_control_parameters.cost_anomaly.address, var.cost_control_defaults.cost_anomaly.address, "")
  threshold_absolute     = try(var.cost_control_parameters.cost_anomaly.threshold_absolute, var.cost_control_defaults.cost_anomaly.threshold_absolute, null)
  threshold_percentage   = try(var.cost_control_parameters.cost_anomaly.threshold_percentage, var.cost_control_defaults.cost_anomaly.threshold_percentage, null)

  tags = local.common_tags
}