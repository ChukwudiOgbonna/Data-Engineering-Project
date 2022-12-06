variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}
variable "region" {
  description = "Value of the region for the aws provider"
  type        = string
  default     = "us-east-1"
}
variable "glue_database_name" {
  description = "Name of our glue database to create"
  type = string
  default = "nyc-trips"
  
}
variable "catalog_id" {
  description = "Glue data catalog ID"
  type = string
  default = "004743222442"
  
}