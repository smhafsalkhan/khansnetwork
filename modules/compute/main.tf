resource "aws_instance" "khansnetwork" {
    count = var.is_instance_create ? 1 : 0
    ami = var.ami_id
    instance_type = var.instance_type
}