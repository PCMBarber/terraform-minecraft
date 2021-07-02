provider "aws" {
    region = "eu-west-2"
    access_key = var.access_key
    secret_key = var.secret_key
}
module "ec2" {
    source          = "./ec2"
    net_id          = module.subnets.net_id
}