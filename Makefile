init:
	terraform init -upgrade
	
plan:
	terraform plan -out tfplan -refresh=false

apply:
	terraform apply "tfplan"

destroy-all:
	terraform destroy --auto-approve

destroy:
	terraform destroy "tfplan"