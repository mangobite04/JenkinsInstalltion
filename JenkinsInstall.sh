#Jenkins Installtion
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install -y jenkins

#Replace Jenkins Port
sed -i 's/JENKINS_PORT=""/JENKINS_PORT="9090"/g' /etc/sysconfig/jenkins

#Use the following command at command prompt:
java -jar jenkins.war --httpPort=9090

#If you want to use https use the following command:
java -jar jenkins.war --httpsPort=9090

systemctl start jenkins
systemctl enable jenkins
