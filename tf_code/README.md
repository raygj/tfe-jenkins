_This Terraform code can be used to provision and EC2 instance to run Jenkins or you can use a Jenkins Docker instance_

In a Terraform Cloud or Enterprise environment you could create a repo for this code, link that repo to a Workspace, move variables to the Workspace and execute from there rather than using Terraform OSS. With that approach a Jenkins server is a "click away" for demos or sandbox environments.

# Provision an EC2 instance in AWS
This Terraform configuration provisions an EC2 instance in AWS.
- This branch adds the capability to set a `user_data` variable. 

### Details
- By default, this configuration provisions a Ubuntu 18.04 AMI with type t2.micro in the us-east-1 region. 
- The AMI ID, region, and type can all be set as variables. You can also set the name variable to determine the value set for the Name tag.
- Note that you need to set environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
- The Terraform variable `owner` must also be set. For example: `export TF_VAR_owner=demouser`.

### Terraform steps:
- Example commands from bash terminal:
```
export AWS_ACCESS_KEY_ID=your-access-key-id
export AWS_SECRET_ACCESS_KEY=your-secret-access-key
export TF_VAR_owner=$(whoami)
export TF_VAR_count=2
terraform init
terraform plan
terraform apply --auto-approve=true
```

### Destroy steps:
- Example commands from bash terminal:
```
terraform destroy
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
```

