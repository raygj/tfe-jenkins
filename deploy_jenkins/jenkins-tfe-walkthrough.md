# Jenkins-TFE-Vault
-Info: TFE API-driven workflow
	- https://www.terraform.io/docs/enterprise/run/api.html

# bootstrap Ubuntu host
## install docker and java 8
```
sudo snap install docker
sudo apt install openjdk-8-jdk -y
sudo apt install unzip -y
sudo apt install jq -y
```

## install Jenkins
```
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y
```
### change default port
- if required, change default port from 8080 to another port
```
sudo nano /etc/default/jenkins
HTTP_PORT=8800
```
## start Jenkins
`sudo systemctl start jenkins`

### verify status is active(exited)
`sudo systemctl status jenkins`

### interesting side-track: install nginx and configure it to provide SSL frontend to jenkins via vault/consul-template
- https://www.digitalocean.com/community/tutorials/how-to-configure-jenkins-with-ssl-using-an-nginx-reverse-proxy-on-ubuntu-18-04

## check firewall and open port if needed
`sudo ufw status`

#### open 8080 if needed
`sudo ufw allow 8800`

# setup jenkins

## browse to jenkins UI
http://<your_server_ip_or_domain>:8800

### grab the initial admin password
`sudo cat /var/lib/jenkins/secrets/initialAdminPassword`

### customize jenkins
- install suggested plugins

## create first admin user
jray
<password>
Jim Ray
jray@hashicorp.com
login

## install additional plugins
Manage Jenkins > Plugin Manager > Available : Filter "Terraform" : "install without restart"

# setup Jenkins for TFE pipeline

## Jenkins credential setup from UI
- pipeline script includes a call to _credentials_ for the TFE_API_TOKEN
	- credentials is a Jenkins operator function that looks at its internal directory of creds
- TFE_API_TOKEN must be set as a Jenkins Service Account
	- Jenkins > Credentials > System > Global Credentials
	- *Add Credentials*
		- Kind = *Secret Text*
		- Scope = *Global*
		- ID = *tfe_api_token*
		- Secret = *TFE user or team token*

### Jenkins server-side OS Setup
- TFE .terraformrc file must be created and configured on Jenkins server
	- if not, you will receive _"Error configuring the backend "remote": required token could not be found" in the Stage Log_

`sudo nano /var/lib/jenkins/.terraformrc`

```
credentials "jray-ptfe.hashidemos.io" {
  token = "xxx.atlasv1.zzz"
}
```
# Configure Pipeline

## step 1
- new item/create new pipeline; "+" sign on left-hand side of Jenkins dashboard
- provide name
- select _Pipeline_
- click OK

## step 2
- provide description _simple EC2 creation using Terraform Enterprise API and Terraform Remote Backend_
- pipeline section
	- paste contents from /tfe-jenkins/job_files in 
- save
- back to dashboard

# Setup TFE to interact with Jenkins pipeline script
## if you do not have one saved already, create a user or team token from TFE
- Settings > Teams >
- Select user/team to generate the token (must have workspace privileges)
- Enter description, then Generate Token
- Copy the token to a secure location (Vault)

## Workspace Setup
### Manually setup AWS and other vars OR use set-variables.sh
https://github.com/hashicorp/terraform-guides/tree/master/operations/variable-scripts

### TFE general settings through UI for target workspace
- Apply Method = Auto Apply
- Terraform Version = 0.11.14

# TF code prep
- backend.tf must reflect target workspace
- https://github.com/raygj/test-jenkins/blob/master/backend.tf
	- update as needed

# Run job
- schedule job from Jenkins dashboard
- click on the clock-thingy to start a run
- click on the job name to see a detail of the stages
- debug/troubleshoot as required
