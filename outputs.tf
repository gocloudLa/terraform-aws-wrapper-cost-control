output "budget" {
  description = "Budget id, ARN, and name for each entry in cost_control_parameters.budget."
  value = {
    for k, m in module.budget : k => {
      id   = m.id
      arn  = m.arn
      name = m.name
    }
  }
}

output "cost_anomaly" {
  description = "Cost Anomaly Detection monitor and subscription identifiers."
  value = {
    monitor_id       = module.cost_anomaly.monitor_id
    monitor_arn      = module.cost_anomaly.monitor_arn
    subscription_arn = module.cost_anomaly.subscription_arn
  }
}
