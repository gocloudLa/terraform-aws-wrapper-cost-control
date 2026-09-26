output "monitor_id" {
  description = "Cost anomaly monitor identifier."
  value       = try(aws_ce_anomaly_monitor.monitor[0].id, null)
}

output "monitor_arn" {
  description = "Cost anomaly monitor ARN."
  value       = try(aws_ce_anomaly_monitor.monitor[0].arn, null)
}

output "subscription_arn" {
  description = "Cost anomaly subscription ARN."
  value       = try(aws_ce_anomaly_subscription.subscription[0].arn, null)
}
