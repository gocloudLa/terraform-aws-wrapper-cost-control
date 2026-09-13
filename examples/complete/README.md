# Complete Example 🚀

Monthly, daily, and dynamic budgets plus Cost Anomaly Detection.

## 🔧 What's Included

### Analysis of Terraform Configuration

#### Main Purpose
The usual cost-control setup: budgets with optional email, a dynamic limit, and anomaly alerts.

#### Key Features Demonstrated
- **Monthly budget**: limit 2100, thresholds 105 and 120, email to `user@example.com`.
- **Daily budget**: limit 70, threshold 120.
- **Dynamic budget**: limit follows the last 6 months, notifies on actual spend at 110%.
- **EC2 budget** (optional): Amazon EC2 usage only. Keeps `RECORD_TYPE = Usage`.
- **Cost Anomaly Detection**: alert at +10 USD or +20% unexpected spend.

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