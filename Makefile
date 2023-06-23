init:
	terraform init -upgrade

plan:
	rm -f tfplan
	terraform plan -out tfplan 

plan-fast:
	terraform plan -out tfplan -refresh=false 

apply:
	SECONDS=0
	terraform apply "tfplan"
	ELAPSED="Elapsed: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"

destroy-all:
	terraform destroy --auto-approve

destroy:
	terraform destroy "tfplan"

clean:
	rm -rf .terraform/
	rm -f tfplan
	rm -f terraform.lock.hcl