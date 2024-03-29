destroy:
	cd infra/cloudflare && terraform destroy --auto-approve -lock=false
	cd infra/cluster && terraform destroy --auto-approve -lock=false
	cd infra/base && terraform destroy  --auto-approve -lock=false

create: base.infra cluster.infra cf.infra

clean:
	rm -rf .terraform/
	rm -f tfplan
	rm -f terraform.lock.hcl


backend-support.infra:
	cd infra/backend-support &&	terraform init 
	cd infra/backend-support && terraform plan -out tfplan 
	cd infra/backend-support && terraform apply tfplan

base.infra:
	cd infra/base && terraform init -upgrade
	cd infra/base && terraform plan -out tfplan 
	cd infra/base && terraform apply tfplan

cluster.infra:
	cd infra/cluster && terraform init -upgrade
	cd infra/cluster && terraform plan -out tfplan 
	cd infra/cluster && terraform apply tfplan

cf.infra:
	cd infra/cloudflare && terraform init -upgrade
	cd infra/cloudflare && terraform plan -out tfplan 
	cd infra/cloudflare && terraform apply tfplan

