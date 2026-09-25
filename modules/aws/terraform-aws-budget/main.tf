locals {
  # Si está habilitado y no hay sns_topics_targets, se usa default
  enable_sns_default = (length(try(var.subscriber_sns_topic_arns, [])) == 0) ? 1 : 0

  subscriber_sns_topic_arns_tmp = (length(try(var.subscriber_sns_topic_arns, []))
  > 0 ? var.subscriber_sns_topic_arns : [try(data.aws_sns_topic.default[0].arn, "")])
}

data "aws_sns_topic" "default" {
  count = local.enable_sns_default
  name  = var.default_sns_topic_name
}
resource "aws_budgets_budget" "alarms" {
  name              = var.name
  name_prefix       = null
  account_id        = null
  budget_type       = var.budget_type
  limit_amount      = var.limit_amount
  limit_unit        = var.limit_unit
  time_period_start = null
  time_period_end   = null
  time_unit         = var.time_unit

  dynamic "auto_adjust_data" {
    for_each = var.auto_adjust_data != {} ? [var.auto_adjust_data] : []
    content {
      auto_adjust_type      = "HISTORICAL"
      last_auto_adjust_time = null

      historical_options {
        budget_adjustment_period   = try(auto_adjust_data.value.budget_adjustment_period, null)
        lookback_available_periods = null
      }
    }
  }

  metrics = var.metrics

  dynamic "filter_expression" {
    for_each = var.filter_expression != null && var.filter_expression != {} ? [var.filter_expression] : []

    content {
      dynamic "dimensions" {
        for_each = try(filter_expression.value.and, null) == null && try(filter_expression.value.dimensions, null) != null ? [filter_expression.value.dimensions] : []

        content {
          key    = dimensions.value.key
          values = dimensions.value.values
        }
      }

      dynamic "and" {
        for_each = try(filter_expression.value.and, [])

        content {
          dimensions {
            key    = and.value.dimensions.key
            values = and.value.dimensions.values
          }
        }
      }
    }
  }

  dynamic "notification" {
    for_each = var.notifications

    content {
      comparison_operator        = try(notification.value.comparison_operator, "GREATER_THAN")
      threshold                  = notification.value.threshold
      threshold_type             = try(notification.value.threshold_type, "PERCENTAGE")
      notification_type          = notification.value.notification_type
      subscriber_sns_topic_arns  = try(notification.value.subscriber_sns_topic_arns, local.subscriber_sns_topic_arns_tmp, null)
      subscriber_email_addresses = try(notification.value.subscriber_email_addresses, var.subscriber_email_addresses, null)
    }
  }
  dynamic "planned_limit" {
    for_each = var.planned_limit != [] ? var.planned_limit : []
    content {
      start_time = try(planned_limit.value.start_time, null)
      amount     = try(planned_limit.value.amount, null)
      unit       = try(planned_limit.value.unit, null)
    }
  }


  tags = var.tags
}