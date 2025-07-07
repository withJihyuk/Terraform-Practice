# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-bucket-with-jihyuk"
#     key            = "minecraft-spot-instance/terraform.tfstate"
#     region         = "ap-northeast-2"
#     dynamodb_table = "terraform-state-lock-with-jihyuk"
#   }
# }