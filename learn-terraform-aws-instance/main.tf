terraform {
    # provides where to store terraform state data files which are used to keep track of metadata of resources
    backend "s3" {
    bucket = "terraformstatedata"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
  assume_role {
    
  }
}


# contains our source data
resource "aws_s3_bucket" "source" {
  bucket = "chuks-s3-bucket-123"

  tags = {
    Name        = "chuks"
    Environment = "Dev"
  }
}

# fetch crawler iam role, with policies from aws account
data "aws_iam_role" "crawler" {
  name = "AWSGlueServiceRole-gluee"
}
# create a glue data catalog database
resource "aws_glue_catalog_database" "db" {
  name=var.glue_database_name
  
}
# glue crawler to get information, schema and location from s3 bucket and put in glue database
resource "aws_glue_crawler" "example" {
  database_name = aws_glue_catalog_database.db.name
  name          = "chuks-crawler"
  role          = data.aws_iam_role.crawler.arn
  depends_on = [
    aws_glue_catalog_database.db, aws_s3_bucket.source, data.aws_iam_role.crawler
  ]

  s3_target {
    path = "s3://chuks-test-bucket-12/"
  }
}


# type of data catalog we are using for athena - GLUE
resource "aws_athena_data_catalog" "example" {
  name        = "AthenaDataCatalog"
  description = "Glue based Data Catalog"
  type        = "GLUE"

  parameters = {
    "catalog-id" = var.catalog_id
  }
}


# bucket to store query results
resource "aws_s3_bucket" "results" {
  bucket = "results-stored"
}

#athena workgroup
resource "aws_athena_workgroup" "Data" {
  name       = "data"
  depends_on = [aws_s3_bucket.results]
  configuration {
    enforce_workgroup_configuration    = false
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.results.bucket}/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
}

