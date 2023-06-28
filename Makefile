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

clean:
	rm -rf .terraform/
	rm -f tfplan
	rm -f terraform.lock.hcl


infra-base:
	cd infra/backend-support &&	terraform init 
	cd infra/backend-support && terraform plan -out tfplan 
	cd infra/backend-support && terraform apply tfplan

infra-product:
	cd infra/ohkillsh && terraform init 
	cd infra/ohkillsh && terraform plan -out tfplan 
	cd infra/ohkillsh && terraform apply tfplan

