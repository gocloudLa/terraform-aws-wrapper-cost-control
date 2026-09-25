module "wrapper_cost_control" {

  source = "../../"

  metadata = local.metadata

  cost_control_parameters = {
    budget = {
      "monthly-cost-budget" = {
        limit_amount = "2100"
        time_unit    = "MONTHLY"
        notifications = [
          {
            threshold                  = 105                  # Required: Percentage or absolute value that triggers the notification.
            notification_type          = "FORECASTED"         # Required: "ACTUAL" or "FORECASTED".
            comparison_operator        = "GREATER_THAN"       # (optional) "GREATER_THAN" | "LESS_THAN" | "EQUAL_TO". Default "GREATER_THAN".
            threshold_type             = "PERCENTAGE"         # (optional) "PERCENTAGE" | "ABSOLUTE_VALUE". Default "PERCENTAGE".
            subscriber_email_addresses = ["user@example.com"] # (optional) list(string). Extra email recipients for this notification.
            # subscriber_sns_topic_arns  = []                 # (optional) list(string). SNS topic ARNs.
          },
          {
            threshold                  = 120
            notification_type          = "ACTUAL"
            subscriber_email_addresses = ["user@example.com"]
          }
        ]
      },
      "daily-cost-budget" = {
        limit_amount = "70"
        time_unit    = "DAILY"
        notifications = [
          {
            threshold         = 120
            notification_type = "ACTUAL"
          }
        ]
      },
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
      },
      "ec2-monthly-budget" = {
        limit_amount = "500"
        time_unit    = "MONTHLY"
        notifications = [
          {
            threshold         = 80
            notification_type = "FORECASTED"
          },
          {
            threshold         = 100
            notification_type = "ACTUAL"
          }
        ]
        filter_expression = {
          and = [
            {
              dimensions = {
                key    = "RECORD_TYPE"
                values = ["Usage"]
              }
            },
            {
              dimensions = {
                key    = "SERVICE"
                values = ["Amazon Elastic Compute Cloud - Compute"]
              }
            }
          ]
        }
      }
    }
    cost_anomaly = {
      enable               = true # default false
      threshold_absolute   = 10
      threshold_percentage = 20
    }
  }
  cost_control_defaults = var.cost_control_defaults
}