variable "project_name" {
  default = "roboshop"
}

variable "sg_name" {
  default = "mongodb-vpn"
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
        Component = "mongodb"
        Environment = "DEV"
        Terraform = true
  }
}

variable "zone_name" {
  default = "awsdevopschandu.tk"
}