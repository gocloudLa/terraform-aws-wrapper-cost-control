provider "aws" {
  region = local.metadata.aws_region
}

# provider "aws" {
#   alias  = "account_02"
#   region = local.metadata.aws_region
# }
