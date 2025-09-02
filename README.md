# Standard Platform - Terraform Module 🚀🚀
<p align="right"><a href="https://partners.amazonaws.com/partners/0018a00001hHve4AAC/GoCloud"><img src="https://img.shields.io/badge/AWS%20Partner-Advanced-orange?style=for-the-badge&logo=amazonaws&logoColor=white" alt="AWS Partner"/></a><a href="LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-green?style=for-the-badge&logo=apache&logoColor=white" alt="LICENSE"/></a></p>

Welcome to the Standard Platform — a suite of reusable and production-ready Terraform modules purpose-built for AWS environments.
Each module encapsulates best practices, security configurations, and sensible defaults to simplify and standardize infrastructure provisioning across projects.

## 📦 Module: Terraform AWS Cost Control Module
<p align="right"><a href="https://github.com/gocloudLa/terraform-aws-wrapper-cost-control/releases/latest"><img src="https://img.shields.io/github/v/release/gocloudLa/terraform-aws-wrapper-cost-control.svg?style=for-the-badge" alt="Latest Release"/></a><a href=""><img src="https://img.shields.io/github/last-commit/gocloudLa/terraform-aws-wrapper-cost-control.svg?style=for-the-badge" alt="Last Commit"/></a><a href="https://registry.terraform.io/modules/gocloudLa/wrapper-cost-control/aws"><img src="https://img.shields.io/badge/Terraform-Registry-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform Registry"/></a></p>
The Terraform Wrapper for Cost Control simplifies the configuration of monitoring and cost control tools in AWS, facilitating the creation and management of budget alarms in Billing and Cost Anomaly Detection.

### ✨ Features

- 💰 [Management of multiple notifications for budgets](#management-of-multiple-notifications-for-budgets) - It allows defining and managing multiple notifications according to the defined threshold levels.

- 💰 [Budget configuration based on the last few months](#budget-configuration-based-on-the-last-few-months) - It allows you to configure a budget based on the last 6 months to dynamically adjust the threshold.




## 🚀 Quick Start
```hcl
cost_control_parameters = {
    budget = {
      "daily-cost-budget" = {
        limit_amount = "70"
        time_unit    = "DAILY"
        threshold    = [120]
        # default_sns_topic_name = "sns-topic-name" # Default: "${local.common_name}-alarms"
      }
    }
    cost_anomaly = {
      enable               = true # default false
      threshold_absolute   = 10
      threshold_percentage = 20
      # default_sns_topic_name = "sns-topic-name" # Default: "${local.common_name}-alarms"
    }
  }
```


## 🔧 Additional Features Usage

### Management of multiple notifications for budgets
It allows defining and managing multiple notifications according to the defined threshold levels.


<details><summary>Configuration Code</summary>

```hcl
budget = {
      "monthly-cost-budget" = {
        limit_amount               = "2100"
        time_unit                  = "MONTHLY"
        threshold                  = [105, 120]
      }
}
```


</details>


### Budget configuration based on the last few months
It allows you to configure a budget based on the last 6 months to dynamically adjust the threshold.


<details><summary>Configuration Code</summary>

```hcl
budget = {
      "dynamic-monthly-budget" = {
        time_unit = "MONTHLY"
        auto_adjust_data = {
          budget_adjustment_period = 6
        }
        notification_type          = "ACTUAL"
        threshold                  = [110]
      }
}
```


</details>




## 📑 Inputs
| Name                       | Description                                                                                  | Type     | Default                            | Required |
| -------------------------- | -------------------------------------------------------------------------------------------- | -------- | ---------------------------------- | -------- |
| name                       | Name of the resource                                                                         | `string` | `${local.common_name}-${each.key}` | no       |
| budget_type                | Type of budget                                                                               | `string` | `COST`                             | no       |
| default_sns_topic_name     | Default SNS topic name                                                                       | `string` | `local.default_sns_topic_name`     | no       |
| limit_amount               | Budget limit amount                                                                          | `number` | `null`                             | no       |
| limit_unit                 | Unit of the budget limit                                                                     | `string` | `USD`                              | no       |
| time_unit                  | Time unit for the budget                                                                     | `string` | `null`                             | no       |
| auto_adjust_data           | Auto-adjustment data configuration                                                           | `map`    | `{}`                               | no       |
| cost_types                 | Cost type configuration                                                                      | `map`    | `{}`                               | no       |
| planned_limit              | Planned budget limit                                                                         | `number` | `null`                             | no       |
| threshold                  | Threshold when the notification should be sent                                               | `list`   | `[]`                               | no       |
| notification_type          | What kind of budget value to notify on                                                       | `string` | `""`                               | no       |
| subscriber_email_addresses | E-Mail addresses to notify                                                                   | `list`   | `[]`                               | no       |
| subscriber_sns_topic_arns  | SNS topics to notify                                                                         | `list`   | `[data.aws_sns_topic.alerts.arn]`  | no       |
| sensitivity                | Metric expression sensitivity                                                                | `number` | `2`                                | no       |
| enable                     | Enable or disable the creation of Cost Anomaly notifications                                 | `bool`   | `false`                            | no       |
| monitor_type               | The possible type values.                                                                    | `string` | `DIMENSIONAL`                      | no       |
| monitor_dimension          | The dimensions to evaluate (Required, if monitor_type is DIMENSIONAL).                       | `string` | `SERVICE`                          | no       |
| monitor_specification      | A valid JSON representation for the Expression object (Required, if monitor_type is CUSTOM). | `map`    | `{}`                               | no       |
| frequency                  | The frequency that anomaly reports are sent.                                                 | `string` | `IMMEDIATE`                        | no       |
| type                       | The type of subscription.                                                                    | `string` | `SNS`                              | no       |
| address                    | The address of the subscriber.                                                               | `string` | `data.aws_sns_topic.alerts.arn`    | no       |
| threshold_absolute         | The threshold_absolute for anomaly                                                           | `string` | `null`                             | no       |
| threshold_percentage       | The threshold_percentage for anomaly                                                         | `string` | `null`                             | no       |
| tags                       | Common tags for resources                                                                    | `map`    | `local.common_tags`                | no       |








---

## 🤝 Contributing
We welcome contributions! Please see our contributing guidelines for more details.

## 🆘 Support
- 📧 **Email**: info@gocloud.la
- 🐛 **Issues**: [GitHub Issues](https://github.com/gocloudLa/issues)

## 🧑‍💻 About
We are focused on Cloud Engineering, DevOps, and Infrastructure as Code.
We specialize in helping companies design, implement, and operate secure and scalable cloud-native platforms.
- 🌎 [www.gocloud.la](https://www.gocloud.la)
- ☁️ AWS Advanced Partner (Terraform, DevOps, GenAI)
- 📫 Contact: info@gocloud.la

## 📄 License
This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details. 