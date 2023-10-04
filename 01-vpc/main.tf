module "vpc" {
  source = "git::https://github.com/chandrasekharyv/terraform-aws_vpc-advanced.git"
  project_name = var.project_name
  common_tags = var.common_tags
  cidr_block = var.cidr_block
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  database_subnet_cidr = var.database_subnet_cidr
  
  #vpc peering
  is_peering_required = true
  requester_vpc_id = data.aws_vpc.default.id
  default_route_table_id = data.aws_vpc.default.main_route_table_id
  default_vpc_cidr = data.aws_vpc.default.cidr_block
  
  
}