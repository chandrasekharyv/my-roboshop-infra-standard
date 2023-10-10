variable "project_name" {
  default = "roboshop"
}

variable "env" {
  default = "dev"
}
variable "common_tags" {
    default = {
        Project = "Roboshop"
        Component = "Catalogue"
        Environment = "DEV"
        Terraform = true
  }
}

