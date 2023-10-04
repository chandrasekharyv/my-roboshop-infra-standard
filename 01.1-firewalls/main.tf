module "vpn_sg" {
  source = "../../terraform-securitygroup"
  project_name = var.project_name
  sg_name = "roboshop-vpn"
  sg_description = "allowing traffic"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_vpc.default.id
  common_tags = merge(
    var.common_tags,
    {
      Component = "VPN",
      Name = "Roboshop-VPN"
    }
  )
}

module "mongodb_sg" {
  source = "../../terraform-securitygroup"
  project_name = var.project_name
  sg_name = "mongodb"
  sg_description = "allowing traffic"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
      Component = "MongoDB",
      Name = "MongoDB"
    }
  )
}

module "catalogue_sg" {
  source = "../../terraform-securitygroup"
  project_name = var.project_name
  sg_name = "catalogue"
  sg_description = "allow all traffic"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
      Component = "Catalogue",
      Name = "Catalogue"
    }
  )
}

module "web_sg" {
  source = "../../terraform-securitygroup"
  project_name = var.project_name
  sg_name = "web"
  sg_description = "allow all traffic"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
      Component = "Web",
      Name  = "Web"
    }
  )
}

module "app_alb_sg" {
  source = "../../terraform-securitygroup"
  project_name = var.project_name
  sg_name = "App-ALB"
  sg_description = "allow all traffic"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
      Component = "Web"
      Name = "App-ALB"
    }
  )
}

module "web_alb_sg" {
  source = "../../terraform-securitygroup"
  project_name = var.project_name
  sg_name = "Web-ALB"
  sg_description = "allow all traffic"
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = merge(
    var.common_tags,
    {
      Component = "Web"
      Name = "Web-ALB"
    }
  )
}


resource "aws_security_group_rule" "vpn" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = module.vpn_sg.security_group_id
}


# this is allowing connections from all catalogue instances to mongodb
resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  description = "allowing port number 27017 from catalogue"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue_sg.security_group_id
#   cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = module.mongodb_sg.security_group_id
}

# this is allowing traffic from VPN on port no 22 for trouble shooting 
resource "aws_security_group_rule" "mongodb_vpn" {
  type              = "ingress"
  description = "allowing port number 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
#   cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = module.mongodb_sg.security_group_id
}

# this is allowing traffic from vpn to catalogue
resource "aws_security_group_rule" "catalogue_vpn" {
  type              = "ingress"
  description = "allowing port number 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
#   cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = module.catalogue_sg.security_group_id
}

# this is allowing traffic from app alb to catalogue
resource "aws_security_group_rule" "catalogue_app_alb" {
  type              = "ingress"
  description = "allowing port number 8080 from app alb"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.security_group_id
#   cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = module.catalogue_sg.security_group_id
}

# this is allowing traffic from vpn to app alb
resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  description = "allowing port number 80 from vpn"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
#   cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = module.app_alb_sg.security_group_id
}

# this is allowing traffic from web to app alb
resource "aws_security_group_rule" "app_alb_web" {
  type              = "ingress"
  description = "allowing port number 80 from web"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_sg.security_group_id
#   cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = module.app_alb_sg.security_group_id
}

# this is allowing traffic from vpn to web
resource "aws_security_group_rule" "web_vpn" {
  type              = "ingress"
  description = "allowing port number 80 from vpn"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
#   cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = module.web_alb_sg.security_group_id
}

# this is allowing traffic from public alb to web
resource "aws_security_group_rule" "web_web_alb" {
  type              = "ingress"
  description = "allowing port number 80 from web-ALB"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb_sg.security_group_id
#   cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = module.web_alb_sg.security_group_id
}

# this is allowing traffic from public alb to web
resource "aws_security_group_rule" "web_alb_internet" {
  type              = "ingress"
  description = "allowing port number 80 from internet"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
#   cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = module.web_alb_sg.security_group_id
}





