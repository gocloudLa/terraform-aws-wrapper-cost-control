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
        budget_adjustment_period   = lookup(auto_adjust_data.value, "budget_adjustment_period", null)
        lookback_available_periods = null
      }
    }
  }
  dynamic "cost_types" {
    for_each = var.cost_types != {} ? [var.cost_types] : []

    content {
      include_credit             = lookup(cost_types.value, "include_credit", null)
      include_discount           = lookup(cost_types.value, "include_discount", null)
      include_other_subscription = lookup(cost_types.value, "include_other_subscription", null)
      include_recurring          = lookup(cost_types.value, "include_recurring", null)
      include_refund             = lookup(cost_types.value, "include_refund", null)
      include_subscription       = lookup(cost_types.value, "include_subscription", null)
      include_support            = lookup(cost_types.value, "include_support", null)
      include_tax                = lookup(cost_types.value, "include_tax", null)
      include_upfront            = lookup(cost_types.value, "include_upfront", null)
      use_amortized              = lookup(cost_types.value, "use_amortized", null)
      use_blended                = lookup(cost_types.value, "use_blended", null)
    }
  }

  dynamic "notification" {
    for_each = var.threshold != [] ? var.threshold : []

    content {
      comparison_operator        = "GREATER_THAN"
      threshold                  = notification.value
      threshold_type             = "PERCENTAGE"
      notification_type          = try(var.notification_type, null)
      subscriber_sns_topic_arns  = try(local.subscriber_sns_topic_arns_tmp, null)
      subscriber_email_addresses = try(var.subscriber_email_addresses, null)
    }
  }
  dynamic "planned_limit" {
    for_each = var.planned_limit != [] ? var.planned_limit : []
    content {
      start_time = lookup(planned_limit.value, "start_time", null)
      amount     = lookup(planned_limit.value, "amount", null)
      unit       = lookup(planned_limit.value, "unit", null)
    }
  }


  tags = var.tags
}