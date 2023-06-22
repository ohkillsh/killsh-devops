init:
	terraform init -upgrade

plan:
	rm -f tfplan
	terraform plan -out tfplan 

plan-fast:
	terraform plan -out tfplan -refresh=false

apply:
	terraform apply "tfplan"

destroy-all:
	terraform destroy --auto-approve

destroy:
	terraform destroy "tfplan"