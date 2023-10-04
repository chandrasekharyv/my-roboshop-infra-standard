variable "project_name" {
  default = "roboshop"
}

variable "sg_name" {
  default = "roboshop-vpn"
}

variable "sg_description" {
  default = "allow all ports from my own ip "
}

variable "env" {
  default = "dev"
  
}
variable "common_tags" {
    default = {
        Project = "roboshop"
        Component = "vpn"
        Environment = "DEV"
        Terraform = true
  }
}