# Dev environment variables
# DO NOT commit sensitive values to Git

aws_region     = "us-west-2"
environment    = "development"
project_name   = "cloudinfra"
instance_count = 1
instance_type  = "t3.micro"
ami            = "ami-06d455b8b50b0de4d"
key_name       = "terra-key-ec2"

db_instance_class = "db.t3.micro"
db_name           = "devdb"
db_username       = "devadmin"
db_password       = "ChangeMe123!"
