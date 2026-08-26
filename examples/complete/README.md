# Complete Example 🚀

This example demonstrates a comprehensive Terraform configuration for cost control using a module named 'wrapper_cost_control'. It includes setting up various budgets and cost anomaly detection.

## 🔧 What's Included

### Analysis of Terraform Configuration

#### Main Purpose
The main purpose is to manage and control cloud costs using predefined budgets and anomaly detection.

#### Key Features Demonstrated
- **Monthly Cost Budget**: A budget with a monthly limit of 2100, time unit set to MONTHLY, and thresholds at 105 and 120.
- **Daily Cost Budget**: A budget with a daily limit of 70, time unit set to DAILY, and a threshold at 120.
- **Dynamic Monthly Budget**: A budget with automatic adjustment every 6 months, notification type set to ACTUAL, and a threshold at 110.
- **EC2 Filtered Budget**: A budget filtered to Amazon EC2 service only, with a monthly limit of 500, using BLENDED_COST metrics and thresholds at 80 and 100.
- **Support Charges Budget**: A budget filtered by CHARGE_TYPE dimension to track support charges, with a monthly limit of 100 and thresholds at 90 and 100.
- **Usage Only Budget**: A budget filtering by Charge Type: Usage using UnblendedCost metrics, with a monthly limit of 1500 and thresholds at 80 and 100.
- **Cost Anomaly Detection**: Enabled with an absolute threshold of 10 and a percentage threshold of 20.

## 🚀 Quick Start

```bash
terraform init
terraform plan
terraform apply
```

## 🔒 Security Notes

⚠️ **Production Considerations**: 
- This example may include configurations that are not suitable for production environments
- Review and customize security settings, access controls, and resource configurations
- Ensure compliance with your organization's security policies
- Consider implementing proper monitoring, logging, and backup strategies

## 📖 Documentation

For detailed module documentation and additional examples, see the main [README.md](../../README.md) file. 