# Upgrade from v1.x to v2.0

If you have a question regarding this upgrade process, please check the code in the `examples/complete` directory.

If you found a bug, please open an issue in this repository.

## List of Changes

1. **Budget notifications** – `threshold`, `notification_type`, `subscriber_email_addresses`, and `subscriber_sns_topic_arns` were removed from each budget entry. Alarms are now a `notifications` list. Each object has its own `threshold` and `notification_type`.
2. **Notification type is required** – v1.x applied one `notification_type` to every threshold, and defaulted it to `ACTUAL` when `time_unit` was `DAILY` and `FORECASTED` otherwise. Set `notification_type` on every notification. That default is gone.
3. **Subscribers are per notification** – email addresses and SNS topic ARNs used to apply to every threshold of the budget. Copy them onto each notification that should keep them. A notification with no `subscriber_sns_topic_arns` still uses the default SNS topic.
4. **`cost_control_defaults.budget`** – the same four keys were replaced by `notifications`.

`comparison_operator` and `threshold_type` are optional on each notification. They still default to `GREATER_THAN` and `PERCENTAGE`.

## Example upgrade procedure

### Legacy (v1.x) `main.tf`

```hcl
cost_control_parameters = {
  budget = {
    "monthly-cost-budget" = {
      limit_amount               = "2100"
      time_unit                  = "MONTHLY"
      threshold                  = [105, 120]
      subscriber_email_addresses = ["user@example.com"]
      # notification_type = "FORECASTED" # Default when time_unit is not DAILY
    }

    "daily-cost-budget" = {
      limit_amount = "70"
      time_unit    = "DAILY"
      threshold    = [120]
      # notification_type = "ACTUAL" # Default when time_unit is DAILY
    }

    "dynamic-monthly-budget" = {
      time_unit = "MONTHLY"
      auto_adjust_data = {
        budget_adjustment_period = 6
      }
      notification_type = "ACTUAL"
      threshold         = [110]
    }
  }
}
```

### New (v2.0) `main.tf`

```hcl
cost_control_parameters = {
  budget = {
    "monthly-cost-budget" = {
      limit_amount = "2100"
      time_unit    = "MONTHLY"
      notifications = [
        {
          threshold                  = 105
          notification_type          = "FORECASTED"
          subscriber_email_addresses = ["user@example.com"]
        },
        {
          threshold                  = 120
          notification_type          = "FORECASTED"
          subscriber_email_addresses = ["user@example.com"]
        }
      ]
    }

    "daily-cost-budget" = {
      limit_amount = "70"
      time_unit    = "DAILY"
      notifications = [
        {
          threshold         = 120
          notification_type = "ACTUAL"
        }
      ]
    }

    "dynamic-monthly-budget" = {
      time_unit = "MONTHLY"
      auto_adjust_data = {
        budget_adjustment_period = 6
      }
      notifications = [
        {
          threshold         = 110
          notification_type = "ACTUAL"
        }
      ]
    }
  }
}
```

Each former `threshold` value becomes one object. Repeat `subscriber_email_addresses` and `subscriber_sns_topic_arns` on every object that should keep the v1.x recipients. v2.0 also lets those objects use different types, operators, and subscribers on the same budget.
