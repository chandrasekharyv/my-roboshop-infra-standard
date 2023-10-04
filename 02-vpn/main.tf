module "vpn_sg" {
  source = "git::https://github.com/chandrasekharyv/terraform-securitygroup.git"
  project_name = var.project_name
  sg_name = var.sg_name
  sg_description = var.sg_description
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_vpc.default.id
  common_tags = var.common_tags
}


resource "aws_security_group_rule" "vpn" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = module.vpn_sg.security_group_id
}

module "vpn_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.devops_ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.vpn_sg.security_group_id]
  #subnet_id = data.aws_vpc.default.public_subnet_ids
  #subnet id is optional for default vpc
  tags = merge(
    {
        Name = "Roboshop-VPN"
    },
    var.common_tags
  )


}