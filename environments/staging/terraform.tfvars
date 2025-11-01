# Staging environment variables
# DO NOT commit sensitive values to Git

aws_region     = "us-west-2"
environment    = "staging"
project_name   = "cloudinfra"
instance_count = 1
instance_type  = "t3.micro"
ami            = "ami-06d455b8b50b0de4d"
key_name       = "terra-key-ec2"

db_instance_class = "db.t3.micro"
db_name           = "stagingdb"
db_username       = "stagingadmin"
db_password       = "ChangeMe123!"
