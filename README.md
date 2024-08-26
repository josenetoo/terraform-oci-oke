### Using this example
Update terraform.tfvars with the required information.

### Deploy  
Initialize Terraform:
```
$ terraform init
```
View what Terraform plans do before actually doing it:
```
$ terraform plan --var-file=terraform.tfvars
```
Use Terraform to Provision resources:
```
$ terraform apply --var-file=terraform.tfvars
```
