init:
	terraform init -upgrade

plan:
	rm -f tfplan 2>&1 /dev/null
	terraform plan -out tfplan 

plan-fast:
	terraform plan -out tfplan -refresh=false 

apply:
	SECONDS=0
	terraform apply "tfplan"
	ELAPSED="Elapsed: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
	echo $ELAPSED

destroy-all:
	terraform destroy --auto-approve

destroy:
	terraform destroy "tfplan"

clean:
	rm -rf .terraform/ 2>&1 /dev/null
	rm -f tfplan 2>&1 /dev/null
	rm -f terraform.lock.hcl 2>&1 /dev/null