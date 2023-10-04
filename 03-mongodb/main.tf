module "mongodb_sg" {
  source = "git::https://github.com/chandrasekharyv/terraform-securitygroup.git"
  project_name = var.project_name
  sg_name = var.sg_name
  sg_description = var.sg_description
  #sg_ingress_rules = var.sg_ingress_rules
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
}

resource "aws_security_group_rule" "mongodb_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = data.aws_ssm_parameter.vpn_sg_id.value
#   cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  security_group_id = module.mongodb_sg.security_group_id
}


module "vpn_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.devops_ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.mongodb_sg.security_group_id]
  subnet_id = local.db_subnet_id
  #subnet id is optional for default vpc
  user_data = file("mongodb.sh")
  tags = merge(
    {
        Name = "MongoDB"
    },
    var.common_tags
  )


}
