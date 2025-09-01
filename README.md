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