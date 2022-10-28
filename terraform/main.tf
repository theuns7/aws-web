# This is the main terrafrom file.
# Author: Theuns Steyn

module "securitygroups" {
  source = "./modules/securitygroups"
  vpc_id          = var.vpc_id
}

module "iam" {
  source = "./modules/iam"
}

module "ecs" {
  source = "./modules/ecs"
  security_group_ids = [module.securitygroups.allow_http_in_sg_id, module.securitygroups.allow_all_out_sg_id]
  subnet_ids         = [var.subnet_a_id, var.subnet_b_id]
  lb_tg_arn       = module.alb.ecs_target_group.arn
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
}

module "alb" {
  source = "./modules/alb"
  security_group_ids = [module.securitygroups.allow_http_in_sg_id, module.securitygroups.allow_all_out_sg_id]
  subnet_ids         = [var.subnet_a_id, var.subnet_b_id]
  vpc_id          = var.vpc_id
}

module "waf" {
  source = "./modules/waf"
  alb_arn         = module.alb.alb.arn
}

module "cloudfront" {
  source = "./modules/cloudfront"
  alb_dns_name    = module.alb.alb.dns_name
}

module "autoscaling" {
  source = "./modules/autoscaling"
  ecs_cluster = module.ecs.ecs_cluster
  ecs_service = module.ecs.ecs_service
}
