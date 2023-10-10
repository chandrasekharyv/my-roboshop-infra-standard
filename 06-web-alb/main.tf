resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-${var.common_tags.Component}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",",data.aws_ssm_parameter.public_subnet_ids.value)

 tags = var.common_tags
}


resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"

  #this will add one listener on port number 443 and one default rule
  default_action {
    type = "fixed-response"

     fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content from App ALB"
      status_code  = "200"
    }
  }
}