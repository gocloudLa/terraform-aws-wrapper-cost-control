output "id" {
  description = "Budget identifier."
  value       = aws_budgets_budget.alarms.id
}

output "arn" {
  description = "Budget ARN."
  value       = aws_budgets_budget.alarms.arn
}

output "name" {
  description = "Budget name."
  value       = aws_budgets_budget.alarms.name
}
