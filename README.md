The 3-tier architecture consists of a Web tier , Application tier and a Database Tier.
The WEB tier — This is the user interface and communication layer of an application.
The Application tier — This is the heart of the architecture. It is where information is processed.
The Database Tier — This is where information will be stored and managed.

Now let us deploy a 3-tier application in AWS using Terraform and Jenkins Pipeline:

![image](https://github.com/user-attachments/assets/a2c63c02-af75-4194-a0ec-3901034e2b61)

Prerequisites:

An AWS Account.
AWS Access and Secret Key.
Configure your IAM user in aws cli.
Basic knowledge of AWS services and Terraform.
Terraform.

Step 1: Create main.tf file that contain the provider and the definitions of all modules:
  we have five modules:
    1- vpc module
    2- web module 
    3- app module
    4- ami module
    5- database module

step 2: create output.tf to show the url of web load balancer od dns name.

step 3: craete vars.tf tp define the cidr variables and key pair.

step 4: create vpc folder that contain main.tf , output.tf and vars.tf of vpc module:
        - in main.tf define the cidrs of VPC , two public subnets and 4 private subnet also contain igw , route table and routable association.

step 5: create ami folder to define ami module 
        - in main.tf : create ec2 to craete custom images from it one for app tier and one for web tier

 step 6: for web module, main.tf contains SG of web LB and web servers SG , launch template , ASG and load balancer

 Step 7: For app tier, main.tf contains SG of app LB and app servers SG , launch template , ASG and load balancer.

 step 8: in database module, we craete database subnet group and database instance.
 
 
