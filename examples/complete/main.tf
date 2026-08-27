module "wrapper_cost_control" {

  source = "../../"

  metadata = local.metadata

  cost_control_parameters = {
    budget = {
      "monthly-cost-budget" = {
        limit_amount = "2100"
        time_unit    = "MONTHLY"
        threshold    = [105, 120]
        # default_sns_topic_name = "sns-topic-name" # Default: "${local.common_name}-alarms"
      },
      "daily-cost-budget" = {
        limit_amount = "70"
        time_unit    = "DAILY"
        threshold    = [120]
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
        metrics      = ["BLENDED_COST"]
        filter_expression = {
          dimensions = {
            key    = "SERVICE"
            values = ["Amazon Elastic Compute Cloud - Compute"]
          }
        }
      },
      "support-charges-budget" = {
        limit_amount = "100"
        time_unit    = "MONTHLY"
        threshold    = [90, 100]
        filter_expression = {
          dimensions = {
            key    = "CHARGE_TYPE"
            values = ["Support"]
          }
        }
      },
      "usage-only-budget" = {
        limit_amount = "1500"
        time_unit    = "MONTHLY"
        threshold    = [80, 100]
        metrics      = ["UnblendedCost"]
        filter_expression = {
          dimensions = {
            key    = "RECORD_TYPE"
            values = ["Usage"]
          }
        }
      }
    }
    cost_anomaly = {
      enable               = true # default false
      threshold_absolute   = 10
      threshold_percentage = 20
      # default_sns_topic_name = "sns-topic-name" # Default: "${local.common_name}-alarms"
    }
  }
  cost_control_defaults = var.cost_control_defaults
}