variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC_cidr block"
  type        = string
}
##################################
## Presentation Tier CIDR Block 1 ##
##################################
variable "public_subnet1_cidr" {
  default     = "10.0.1.0/24"
  description = "public_web_subnet1"
  type        = string
}
################################
## Presentation Tier CIDR Block 2##
###############################
variable "public_subnet2_cidr" {
  default     = "10.0.2.0/24"
  description = "public_web_subnet2"
  type        = string
}
#########################
## App tier CIDR Block 1##
#########################
variable "private_subnet1_cidr" {
  default     = "10.0.3.0/24"
  description = "private_app_subnet1"
  type        = string
}
############################
## App tier CIDR Block 2 ##
###########################
variable "private_subnet2_cidr" {
  default     = "10.0.4.0/24"
  description = "private_app_subnet2"
  type        = string
}
####################
## DB CIDR Block 1 ##
####################
variable "private_subnet3_cidr" {
  default     = "10.0.5.0/24"
  description = "private_db_subnet1"
  type        = string
}
####################
## DB CIDR Block 2 ##
####################
variable "private_subnet4_cidr" {
  default     = "10.0.6.0/24"
  description = "private_db_subnet2"
  type        = string
}



