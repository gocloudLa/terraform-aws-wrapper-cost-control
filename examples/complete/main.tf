module "wrapper_cost_control" {

  source = "../../"

  metadata = local.metadata

  cost_control_parameters = {
    budget = {
      "monthly-cost-budget" = {
        limit_amount               = "2100"
        time_unit                  = "MONTHLY"
        threshold                  = [105, 120]
        subscriber_email_addresses = ["user@example.com"]
        # notification_type = "FORECASTED" # Default
      },
      "daily-cost-budget" = {
        limit_amount = "70"
        time_unit    = "DAILY"
        threshold    = [120]
        # notification_type = "ACTUAL" # Default
      },
      "dynamic-monthly-budget" = {
        time_unit = "MONTHLY"
        auto_adjust_data = {
          budget_adjustment_period = 6
        }
        notification_type = "ACTUAL"
        threshold         = [110]
      },
      "ec2-monthly-budget" = {
        limit_amount = "500"
        time_unit    = "MONTHLY"
        threshold    = [80, 100]
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