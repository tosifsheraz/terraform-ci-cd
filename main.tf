

variable "vcs_repo" {
  type = object({ identifier = string, branch = string })
}


module "s3backend" {
  source         = "terraform-in-action/s3backend/aws"
  principal_arns = [module.codepipeline.deployment_role_arn]
}

module "codepipeline" {
  source   = "./modules/codepipeline"
  name     = "terraform-in-action"
  vcs_repo = var.vcs_repo

  environment = {
    CONFIRM_DESTROY = 1
  }

  deployment_policy = file("./policies/helloworld.json")
  s3_backend_config = module.s3backend.config
}


provider "aws" {
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}




