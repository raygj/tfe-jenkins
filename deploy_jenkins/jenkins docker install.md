#Step 1: install docker on Ubuntu:
```curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu```
#Step 2: Run jenkins container
```sudo mkdir /var/jenkins_home
sudo chown -R docker /var/jenkins_home
sudo chmod u+rwx /var/jenkins_home
docker run -d -n jenkins_master -p 9000:8080 -p 9000:9000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-alpine```
#Step 3: Get jenkins password:
```docker exec jenkins-master cat /var/jenkins_home/secrets/initialAdminPassword > /tmp/jenkinspassword.txt
docker inspect -f '{{ .Mounts }}' jenkins-master```
#Step 4: access jenkins on port (default 8080)