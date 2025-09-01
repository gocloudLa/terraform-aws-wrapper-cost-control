resource "aws_ce_anomaly_monitor" "monitor" {
  count = var.enable ? 1 : 0

  name                  = var.name
  monitor_type          = var.monitor_type
  monitor_dimension     = var.monitor_type == "DIMENSIONAL" ? var.monitor_dimension : null
  monitor_specification = var.monitor_type == "CUSTOM" ? jsonencode(var.monitor_specification) : null

  tags = var.tags
}

locals {
  # Si está habilitado y no hay address, se usa default
  enable_sns_default = try(var.enable, false) && (try(var.address, "") == "") ? 1 : 0

  address_tmp = (try(var.address, "") != "" ? var.address : try(data.aws_sns_topic.default[0].arn, ""))
}

data "aws_sns_topic" "default" {
  count = local.enable_sns_default

  name = var.default_sns_topic_name
}

resource "aws_ce_anomaly_subscription" "subscription" {
  count = var.enable ? 1 : 0

  name             = "${var.name}-subscription"
  frequency        = "IMMEDIATE"
  monitor_arn_list = [aws_ce_anomaly_monitor.monitor[0].arn]

  subscriber {
    type    = var.type
    address = try(local.address_tmp, null)
  }

  threshold_expression {
    or {
      dimension {
        key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
        match_options = ["GREATER_THAN_OR_EQUAL"]
        values        = [var.threshold_absolute]
      }
    }
    or {
      dimension {
        key           = "ANOMALY_TOTAL_IMPACT_PERCENTAGE"
        match_options = ["GREATER_THAN_OR_EQUAL"]
        values        = [var.threshold_percentage]
      }
    }
  }

  tags = var.tags
}