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
