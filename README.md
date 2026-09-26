# Standard Platform - Terraform Module 🚀🚀
<p align="right"><a href="https://partners.amazonaws.com/partners/0018a00001hHve4AAC/GoCloud"><img src="https://img.shields.io/badge/AWS%20Partner-Advanced-orange?style=for-the-badge&logo=amazonaws&logoColor=white" alt="AWS Partner"/></a><a href="LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-green?style=for-the-badge&logo=apache&logoColor=white" alt="LICENSE"/></a></p>

Welcome to the Standard Platform — a suite of reusable and production-ready Terraform modules purpose-built for AWS environments.
Each module encapsulates best practices, security configurations, and sensible defaults to simplify and standardize infrastructure provisioning across projects.

## 📦 Module: Terraform Cost Control Module
<p align="right"><a href="https://github.com/gocloudLa/terraform-aws-wrapper-cost-control/releases/latest"><img src="https://img.shields.io/github/v/release/gocloudLa/terraform-aws-wrapper-cost-control.svg?style=for-the-badge" alt="Latest Release"/></a><a href=""><img src="https://img.shields.io/github/last-commit/gocloudLa/terraform-aws-wrapper-cost-control.svg?style=for-the-badge" alt="Last Commit"/></a><a href="https://registry.terraform.io/modules/gocloudLa/wrapper-cost-control/aws"><img src="https://img.shields.io/badge/Terraform-Registry-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform Registry"/></a></p>
Configures AWS spend limits and alerts, and can flag charges that fall outside the usual pattern.


### ✨ Features

- 💰 [Budgets](#budgets) - Set a limit, a period, and one or more notifications. Alarms go to SNS by default. Add subscriber_email_addresses to also send email.

- 📈 [Dynamic budget](#dynamic-budget) - The limit is the average of the last X months. threshold 110 means 10% above that average.

- 🚨 [Cost Anomaly Detection](#cost-anomaly-detection) - Optional. A budget caps spend. Anomaly detection flags charges that do not match the usual pattern. Off by default.

- 🔍 [Usage only by default](#usage-only-by-default) - Every budget ignores credits and refunds unless you override filter_expression.

- 🎯 [Alert on a single service](#alert-on-a-single-service) - Optional. Scope a budget to one AWS service. Keep the Usage filter or credits can hide spend again.




## 🚀 Quick Start
```hcl
cost_control_parameters = {
  budget = {
    "monthly-cost-budget" = {
      limit_amount = "2100"
      time_unit    = "MONTHLY"
      notifications = [
        {
          threshold           = 105            # Required: Percentage or absolute value that triggers the notification.
          notification_type   = "FORECASTED"   # Required: "ACTUAL" or "FORECASTED".
          # comparison_operator = "GREATER_THAN" # (optional) "GREATER_THAN" | "LESS_THAN" | "EQUAL_TO". Default "GREATER_THAN".
          # threshold_type      = "PERCENTAGE"   # (optional) "PERCENTAGE" | "ABSOLUTE_VALUE". Default "PERCENTAGE".
          # subscriber_email_addresses = ["user@example.com"] # (optional) list(string). Extra email recipients for this notification.
          # subscriber_sns_topic_arns  = []                   # (optional) list(string). SNS topic ARNs. If it not declare, the value is default sns topic
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
    }
  }
  cost_anomaly = {
    enable               = true # Default: false
    threshold_absolute   = 10
    threshold_percentage = 20
  }
}
```


## 🔧 Additional Features Usage

### Budgets
Each budget needs `limit_amount`, `time_unit`, and a `notifications` list. Every entry defines its own `threshold` and `notification_type` (`ACTUAL` or `FORECASTED`), so a single budget can hold several alarms.

Notifications go to the default SNS topic. Add `subscriber_email_addresses` on a notification to also email someone.


<details><summary>Monthly and daily</summary>

```hcl
cost_control_parameters = {
  budget = {
    "monthly-cost-budget" = {
      limit_amount = "2100"
      time_unit    = "MONTHLY"
      notifications = [
        {
          threshold           = 105            # Required: Percentage or absolute value that triggers the notification.
          notification_type   = "FORECASTED"   # Required: "ACTUAL" or "FORECASTED".
          comparison_operator = "GREATER_THAN" # (optional) "GREATER_THAN" | "LESS_THAN" | "EQUAL_TO". Default "GREATER_THAN".
          threshold_type      = "PERCENTAGE"   # (optional) "PERCENTAGE" | "ABSOLUTE_VALUE". Default "PERCENTAGE".
          # subscriber_email_addresses = ["user@example.com"] # (optional) list(string). Extra email recipients for this notification.
          # subscriber_sns_topic_arns  = []                 # (optional) list(string). SNS topic ARNs. If it not declare, the value is default sns topic
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
    }
  }
}
```


</details>


### Dynamic budget
You do not set `limit_amount`. AWS sets the limit to the average of the last N months (`budget_adjustment_period`).

A notification with `threshold = 110` means the alarm fires at 10% above that average. `notification_type = ACTUAL` uses spent-to-date.


<details><summary>Last 6 months</summary>

```hcl
cost_control_parameters = {
  budget = {
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


</details>


### Cost Anomaly Detection
Enable it when AWS should alert on unexpected spikes, even while spend is still under the budget.

`threshold_absolute` alerts when unexpected spend reaches that many USD. `threshold_percentage` alerts when unexpected spend is at least that percent above what AWS expected. Either condition can fire the alert. Set both when `enable` is true.


<details><summary>Enable</summary>

```hcl
cost_control_parameters = {
  cost_anomaly = {
    enable               = true # Default: false
    threshold_absolute   = 10
    threshold_percentage = 20
  }
}
```


</details>


### Usage only by default
You do not need to set `filter_expression`. Every budget measures `RECORD_TYPE = Usage` unless you replace that filter.

Credits are a separate charge type. If they stay in the budget, net spend can remain under the limit and alarms never fire.


<details><summary>Applied by default</summary>

```hcl
cost_control_parameters = {
  budget = {
    "monthly-cost-budget" = {
      filter_expression = {
        dimensions = {
          key    = "RECORD_TYPE"
          values = ["Usage"]
        }
      }
    }
  }
}
```


</details>


### Alert on a single service
Setting `filter_expression` replaces the default. Keep `RECORD_TYPE = Usage` and add the service with `and`.


<details><summary>EC2 usage only</summary>

```hcl
cost_control_parameters = {
  budget = {
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
      filter_expression = { # Default: RECORD_TYPE = Usage
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
}
```


</details>




## 📑 Inputs
| Name                                            | Description                                                                                                             | Type     | Default                                                        | Required |
| ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | -------- | -------------------------------------------------------------- | -------- |
| budget.default_sns_topic_name                   | SNS topic name when a notification has no subscriber topic ARNs                                                         | `string` | `${common_name}-alerts`                                        | no       |
| budget.name                                     | Budget name. Defaults to `${common_name}-${key}`                                                                        | `string` | `${common_name}-${key}`                                        | no       |
| budget.auto_adjust_data                         | Set `budget_adjustment_period` (months). The limit becomes the average of those months                                  | `map`    | `{}`                                                           | no       |
| budget.budget_type                              | What the budget tracks. `COST` is money                                                                                 | `string` | `COST`                                                         | no       |
| budget.limit_amount                             | Budget limit. Omit when `auto_adjust_data` sets the limit                                                               | `number` | `null`                                                         | no       |
| budget.limit_unit                               | Unit of `limit_amount`                                                                                                  | `string` | `USD`                                                          | no       |
| budget.time_unit                                | How often the budget resets. `MONTHLY`, `DAILY`, `QUARTERLY`, or `ANNUALLY`                                             | `string` | `null`                                                         | no       |
| budget.notifications                            | Notification objects. Each budget can hold several alarms                                                               | `list`   | `[]`                                                           | no       |
| budget.notifications.threshold                  | Percentage or absolute value that triggers the notification                                                             | `number` | —                                                              | yes      |
| budget.notifications.notification_type          | `ACTUAL` or `FORECASTED`                                                                                                | `string` | —                                                              | yes      |
| budget.notifications.comparison_operator        | `GREATER_THAN`, `LESS_THAN`, or `EQUAL_TO`                                                                              | `string` | `GREATER_THAN`                                                 | no       |
| budget.notifications.threshold_type             | `PERCENTAGE` or `ABSOLUTE_VALUE`                                                                                        | `string` | `PERCENTAGE`                                                   | no       |
| budget.notifications.subscriber_email_addresses | Extra email recipients for this notification                                                                            | `list`   | `null`                                                         | no       |
| budget.notifications.subscriber_sns_topic_arns  | SNS topic ARNs for this notification. Empty uses the default topic                                                      | `list`   | `[]`                                                           | no       |
| budget.planned_limit                            | Planned limits for future periods                                                                                       | `list`   | `[]`                                                           | no       |
| budget.filter_expression                        | Scope the budget. Replaces the Usage-only default. Keep `RECORD_TYPE = Usage` with `and` when you add another dimension | `map`    | `{ dimensions = { key = "RECORD_TYPE", values = ["Usage"] } }` | no       |
| budget.metrics                                  | Cost metrics included in the budget calculation                                                                         | `list`   | `["UnblendedCost"]`                                            | no       |
| budget.tags                                     | Tags merged onto the budget                                                                                             | `map`    | `null`                                                         | no       |
| cost_anomaly.address                            | SNS topic ARN or email. Empty uses the default alarms topic                                                             | `string` | `""`                                                           | no       |
| cost_anomaly.default_sns_topic_name             | SNS topic name used when `address` is empty                                                                             | `string` | `${common_name}-alerts`                                        | no       |
| cost_anomaly.enable                             | Turns on Cost Anomaly Detection                                                                                         | `bool`   | `false`                                                        | no       |
| cost_anomaly.name                               | Monitor name                                                                                                            | `string` | `${common_name}-cost-anomaly`                                  | no       |
| cost_anomaly.type                               | Subscriber type                                                                                                         | `string` | `SNS`                                                          | no       |
| cost_anomaly.monitor_type                       | `DIMENSIONAL` or `CUSTOM`                                                                                               | `string` | `DIMENSIONAL`                                                  | no       |
| cost_anomaly.monitor_dimension                  | Dimension to evaluate when `monitor_type` is `DIMENSIONAL`                                                              | `string` | `SERVICE`                                                      | no       |
| cost_anomaly.monitor_specification              | Custom monitor filter. Used when `monitor_type` is `CUSTOM`                                                             | `map`    | `null`                                                         | no       |
| cost_anomaly.threshold_absolute                 | Alert if unexpected spend is at least this many USD                                                                     | `string` | `null`                                                         | no       |
| cost_anomaly.threshold_percentage               | Alert if unexpected spend is at least this percent above expected                                                       | `string` | `null`                                                         | no       |
| cost_anomaly.tags                               | Tags merged onto the Cost Anomaly resources                                                                             | `map`    | `null`                                                         | no       |







## ⚠️ Important Notes
- ⚠️ **SNS topic must exist:** Budgets and Cost Anomaly look up the alerts topic (`${common_name}-alerts`, unless overridden). They do not create it. The topic has to be in the account before apply.
- ⚠️ **Cost Anomaly thresholds:** When `cost_anomaly.enable` is true, set both `threshold_absolute` and `threshold_percentage`. The subscription publishes both conditions, and a null value fails apply.



---

## 🤝 Contributing
We welcome contributions! Please see our contributing guidelines for more details.

## 🆘 Support
- 📧 **Email**: info@gocloud.la

## 🧑‍💻 About
We are focused on Cloud Engineering, DevOps, and Infrastructure as Code.
We specialize in helping companies design, implement, and operate secure and scalable cloud-native platforms.
- 🌎 [www.gocloud.la](https://www.gocloud.la)
- ☁️ AWS Advanced Partner (Terraform, DevOps, GenAI)
- 📫 Contact: info@gocloud.la

## 📄 License
This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details. 