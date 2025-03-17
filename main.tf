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

module "s3_bucket" {
  source         = "./modules/s3"
  create_bucket  = var.create_bucket  
  bucket_name    = var.bucket_name
  enable_versioning = var.enable_versioning
}