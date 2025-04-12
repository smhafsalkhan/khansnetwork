data "aws_ami" "latest_amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"]
}

module "compute" {
  source = "./modules/compute"
  ami_id = var.latest_ami ? data.aws_ami.latest_amazon_linux.id : var.ami_id
  instance_type = var.instance_type
  instance_name = var.instance_name
  is_instance_create = var.is_instance_create
}

module "s3" {
  source           = "./modules/s3"
  static_dir_path  = "${path.root}/staticfiles"
}

module "sso" {
  source              = "./modules/sso"
  permission_set_name = "TFEAccess"
  s3_bucket_arn       = "arn:aws:s3:::khansnetwork.in"
}