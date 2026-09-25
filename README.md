# Standard Platform - Terraform Module 🚀🚀
<p align="right"><a href="https://partners.amazonaws.com/partners/0018a00001hHve4AAC/GoCloud"><img src="https://img.shields.io/badge/AWS%20Partner-Advanced-orange?style=for-the-badge&logo=amazonaws&logoColor=white" alt="AWS Partner"/></a><a href="LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-green?style=for-the-badge&logo=apache&logoColor=white" alt="LICENSE"/></a></p>

Welcome to the Standard Platform — a suite of reusable and production-ready Terraform modules purpose-built for AWS environments.
Each module encapsulates best practices, security configurations, and sensible defaults to simplify and standardize infrastructure provisioning across projects.

## 📦 Module: Terraform AWS Cost Control Module
<p align="right"><a href="https://github.com/gocloudLa/terraform-aws-wrapper-cost-control/releases/latest"><img src="https://img.shields.io/github/v/release/gocloudLa/terraform-aws-wrapper-cost-control.svg?style=for-the-badge" alt="Latest Release"/></a><a href=""><img src="https://img.shields.io/github/last-commit/gocloudLa/terraform-aws-wrapper-cost-control.svg?style=for-the-badge" alt="Last Commit"/></a><a href="https://registry.terraform.io/modules/gocloudLa/wrapper-cost-control/aws"><img src="https://img.shields.io/badge/Terraform-Registry-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform Registry"/></a></p>
The Terraform Wrapper for Cost Control simplifies the configuration of monitoring and cost control tools in AWS, facilitating the creation and management of budget alarms in Billing and Cost Anomaly Detection.

### ✨ Features

- 💰 [Budgets](#budgets) - Set a limit, a period, and one or more notifications. Alarms go to SNS by default. Add subscriber_email_addresses to also send email.

- 💰 [Dynamic budget](#dynamic-budget) - The limit is the average of the last X months. threshold 110 means 10% above that average.

- 🚨 [Cost Anomaly Detection](#cost-anomaly-detection) - Optional. A budget is "do not exceed X". Anomaly is "this spend is not normal". Off by default.

- 🔍 [Usage only by default](#usage-only-by-default) - Every budget ignores credits and refunds unless you override filter_expression.

- 🔍 [Alert on a single service](#alert-on-a-single-service) - Optional. Scope a budget to one AWS service. Keep the Usage filter or credits can hide spend again.




## 🚀 Quick Start
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
            notification_type          = "ACTUAL"
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
    cost_anomaly = {
      enable               = true
      threshold_absolute   = 10
      threshold_percentage = 20
    }
  }
```


## 🔧 Additional Features Usage

### Budgets
Each budget needs `limit_amount`, `time_unit`, and a `notifications` list. Every entry defines its own `threshold` (percentage) and `notification_type` (`ACTUAL` or `FORECASTED`), so a single budget can hold several alarms.

Notifications go to the default SNS topic. Add `subscriber_email_addresses` on a notification to also email someone.


<details><summary>Monthly and daily</summary>

```hcl
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
            # subscriber_email_addresses = ["user@example.com"] # (optional) list(string). Extra email recipients for this notification.
            # subscriber_sns_topic_arns  = []  
          },
          {
            threshold                  = 120
            notification_type          = "ACTUAL"
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
}
```


</details>


### Dynamic budget
You do not set `limit_amount`. AWS sets the limit to the **average** of the last N months (`budget_adjustment_period`), not to the highest month.

A notification with `threshold = 110` means "alert when this month is 10% above that average". `notification_type = ACTUAL` uses spent-to-date, not the forecast.

Example: last 6 months averaged 1000 USD. The limit this month is 1000. The alarm fires at 1100.


<details><summary>Last 6 months</summary>

```hcl
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
```


</details>


### Cost Anomaly Detection
Enable it when you want AWS to alert on unexpected spikes, even if you are still under the budget.

| Field | What it does |
| --- | --- |
| `enable` | Turns it on. Default `false`. |
| `threshold_absolute` | Alert if unexpected spend is at least this many USD. |
| `threshold_percentage` | Alert if unexpected spend is at least this percent above what AWS expected. |

Either threshold can fire the alert.


<details><summary>Enable</summary>

```hcl
cost_anomaly = {
      enable               = true
      threshold_absolute   = 10
      threshold_percentage = 20
}
```


</details>


### Usage only by default
You do not need to set `filter_expression`. The module adds this block on every budget:

```hcl
filter_expression = {
  dimensions = {
    key    = "RECORD_TYPE"
    values = ["Usage"]
  }
}
```

AWS credits are a separate charge type (a negative amount). If they are included, net spend can stay below the limit and alarms never fire. Measuring Usage only keeps the alarm on real consumption.


<details><summary>Applied by default</summary>

```hcl
filter_expression = {
      dimensions = {
        key    = "RECORD_TYPE"
        values = ["Usage"]
      }
}
```


</details>


### Alert on a single service
Setting `filter_expression` replaces the default. Keep `RECORD_TYPE = Usage` and add the service with `and`.


<details><summary>EC2 usage only</summary>

```hcl
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
```


</details>




## 📑 Inputs
| Name                               | Description                                                                                                                                       | Type     | Default                                                        | Required |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------------------------------------------------------------- | -------- |
| budget.name                        | Map key. Resource name is `${common_name}-${key}`                                                                                                 | `string` | —                                                              | yes      |
| budget.budget_type                 | What the budget tracks. `COST` is money                                                                                                           | `string` | `COST`                                                         | no       |
| budget.limit_amount                | Budget limit                                                                                                                                      | `number` | `null`                                                         | no       |
| budget.limit_unit                  | Unit of `limit_amount`                                                                                                                            | `string` | `USD`                                                          | no       |
| budget.time_unit                   | How often the budget resets. `MONTHLY`, `DAILY`, `QUARTERLY`, or `ANNUALLY`                                                                       | `string` | `null`                                                         | no       |
| budget.notifications               | List of notification objects. Each budget can hold several alarms                                                                                 | `list`   | `[]`                                                           | no       |
| budget.subscriber_email_addresses  | Extra email recipients. SNS is used by default                                                                                                    | `list`   | `[]`                                                           | no       |
| budget.subscriber_sns_topic_arns   | SNS topic ARNs to notify                                                                                                                          | `list`   | `[]`                                                           | no       |
| budget.default_sns_topic_name      | SNS topic name when `subscriber_sns_topic_arns` is empty                                                                                          | `string` | `local.default_sns_topic_name`                                 | no       |
| budget.auto_adjust_data            | Set `budget_adjustment_period` (months). The limit becomes the average of those months                                                            | `map`    | `{}`                                                           | no       |
| budget.planned_limit               | Optional planned limits for future periods                                                                                                        | `list`   | `[]`                                                           | no       |
| budget.filter_expression           | Optional. Scope the budget (for example by `SERVICE`). Replaces the default. Keep `RECORD_TYPE = Usage` with `and` when you add another dimension | `map`    | `{ dimensions = { key = "RECORD_TYPE", values = ["Usage"] } }` | no       |
| budget.metrics                     | Leave unset. The module always counts the budget in USD                                                                                           | `list`   | `["UnblendedCost"]`                                            | no       |
| budget.tags                        | Tags for the budget                                                                                                                               | `map`    | `{}`                                                           | no       |
| cost_anomaly.enable                | Turns on Cost Anomaly Detection                                                                                                                   | `bool`   | `false`                                                        | no       |
| cost_anomaly.threshold_absolute    | Alert if unexpected spend is at least this many USD                                                                                               | `string` | `null`                                                         | no       |
| cost_anomaly.threshold_percentage  | Alert if unexpected spend is at least this percent above expected                                                                                 | `string` | `null`                                                         | no       |
| cost_anomaly.monitor_type          | Monitor type. Leave unset                                                                                                                         | `string` | `DIMENSIONAL`                                                  | no       |
| cost_anomaly.monitor_dimension     | Dimension to evaluate when `monitor_type` is `DIMENSIONAL`                                                                                        | `string` | `SERVICE`                                                      | no       |
| cost_anomaly.monitor_specification | Custom monitor filter. Only used if `monitor_type` is `CUSTOM`                                                                                    | `map`    | `null`                                                         | no       |
| cost_anomaly.type                  | Subscriber type                                                                                                                                   | `string` | `SNS`                                                          | no       |
| cost_anomaly.address               | SNS topic ARN or email. Empty uses the default alarms topic                                                                                       | `string` | `""`                                                           | no       |
| default_sns_topic_name             | SNS topic name used by Cost Anomaly when `cost_anomaly.address` is empty                                                                          | `string` | `local.default_sns_topic_name`                                 | no       |
| tags                               | Tags for Cost Anomaly resources                                                                                                                   | `map`    | `{}`                                                           | no       |








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