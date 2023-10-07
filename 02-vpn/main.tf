module "vpn_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.devops_ami.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  #subnet_id = data.aws_vpc.default.public_subnet_ids
  #subnet id is optional for default vpc
  tags = merge(
    {
        Name = "Roboshop-VPN"
    },
    var.common_tags
  )


}