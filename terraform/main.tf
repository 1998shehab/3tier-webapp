terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}


module "vpc" {
  source = "./modules/vpc"
} 


module "web" {
  source = "./modules/web"
  vpc_main = module.vpc.vpc_main
  public_1 = module.vpc.public_1
  public_2 = module.vpc.public_2
  web_ami  = module.ami.web_ami
  key_pair = var.key_pair
} 


module "app" {
  source = "./modules/app"
  vpc_main = module.vpc.vpc_main
  private_1 = module.vpc.private_1
  private_2 = module.vpc.private_2
  web_sg = module.web.web_sg
  app_ami= module.ami.app_ami
  key_pair = var.key_pair
} 

module "database" {
  source = "./modules/database"
  vpc_main = module.vpc.vpc_main
  private_3 = module.vpc.private_3
  private_4 = module.vpc.private_4
  app_sg = module.app.app_sg
} 

module "ami" {
  source = "./modules/ami"
  public_1 = module.vpc.public_1
  web_lb_sg = module.web.web_lb_sg  
  key_pair = var.key_pair
  database= module.database.database
  app_dnsname = module.app.app_dnsname
} 


