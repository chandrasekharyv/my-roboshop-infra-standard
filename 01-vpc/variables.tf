variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "common_tags" {
    default = {
        Project = "Roboshop"
        Component = "vpc"
        Environment = "DEV"
        Terraform = true
  }
}
variable "project_name" {
  default = "roboshop"
}

variable "env" {
  default = "dev"
  
}

variable "public_subnet_cidr" {
    default = ["10.0.1.0/24","10.0.2.0/24"]
  
}

variable "azs" {
    default = ["us-east-1a","us-east-1b"]
  
}


variable "public_subnet_names" {
    default = ["public-subnet-1a","public-subnet-1b"]
  
}

variable "private_subnet_cidr" {
    default = ["10.0.11.0/24","10.0.12.0/24"]
  
}

variable "private_subnet_names" {
    default = ["private-subnet-1a","private-subnet-1b"]
  
}

variable "database_subnet_cidr" {
  default = ["10.0.21.0/24","10.0.22.0/24"]
}



