module "terraform_infra" {
  source = "git@github.com:ohkillsh/killsh-module-terraform-base-infra.git"

  sp_client_id = "8d864f9e-1b9a-4041-8a40-efdf4c1fd175"
  sp_object_id = "05d276e2-1ef0-425e-a681-5c51636732c8"
  product      = "killsh"
  environment  = "global"
  location     = "eastus"

  user_tags = var.tags

}
