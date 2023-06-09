module "terraform_infra" {
  source = "git@github.com:ohkillsh/killsh-module-terraform-base-infra.git?ref=main"

  sp_client_id = "8d864f9e-1b9a-4041-8a40-efdf4c1fd175"
  sp_object_id = "078af6d6-bb65-44be-97ed-1769d61b178e"
  product      = "killsh"
  environment  = "global"
  location     = "eastus"

  user_tags = var.tags

}
