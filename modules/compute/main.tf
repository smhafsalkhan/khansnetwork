resource "aws_instance" "afsalkhan" {
    count = var.is_instance_create ? 1 : 0
    ami = var.ami_id
    instance_type = var.instance_type
     tags = {
        Name = var.instance_name  
    }
   
}