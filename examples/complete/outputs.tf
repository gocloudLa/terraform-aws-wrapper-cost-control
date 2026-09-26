output "budget" {
  description = "Budget id, ARN, and name for each configured budget."
  value       = module.wrapper_cost_control.budget
}

output "cost_anomaly" {
  description = "Cost Anomaly Detection monitor and subscription identifiers."
  value       = module.wrapper_cost_control.cost_anomaly
}
