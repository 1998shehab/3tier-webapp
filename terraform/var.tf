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

####################
## DB Instance    ##
####################
variable "database-instance-class" {
  default     = "db.t2.micro"
  description = "The Database Instance type"
  type        = string
}
####################
##     multi_AZ    #
####################
variable "multi-az-deployment" {
  default     = false
  description = "Create a Standby DB Instance"
  type        = bool
}

variable "key_pair" {
  type = string
  default = "miro7775000"
}