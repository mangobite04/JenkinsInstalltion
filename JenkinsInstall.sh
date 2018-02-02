#Jenkins Script
#Author : Devesh Kumar Rai
#set -x

#Installtion of wget and Java
yum install -y java-1.8.0 wget

#Get Java Versio
java -version

#Creating Group and User id for tomcat
groupadd tomcat
useradd -g tomcat -d /opt/tomcat -s /bin/nologin tomcat

#Download apache tomcat
wget http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.27/bin/apache-tomcat-8.5.27.tar.gz
wget --no-check-certificate http://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.27/bin/apache-tomcat-8.5.27.tar.gz.md5
cat apache-tomcat-8.5.27.tar.gz.md5

#md5sum verification
md5sum apache-tomcat-8.5.27.tar.gz
tar -zxvf apache-tomcat-*.tar.gz

#Moving apache files to standard directory
mv apache-tomcat-8.5.*/* /opt/tomcat/

#Providing privilages to tomcat directory
chown -R tomcat:tomcat /opt/tomcat/

#Appending /etc/systemd/system/tomcat.service file
cat > /etc/systemd/system/tomcat.service <<"EOFF"

[Unit]
Description=Apache Tomcat 8.x Web Application Container
Wants=network.target
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.141-1.b16.el7_3.x86_64/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1G -Djava.net.preferIPv4Stack=true'
Environment='JAVA_OPTS=-Djava.awt.headless=true'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
SuccessExitStatus=143

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOFF

#Replacing rolename and username in xml file
sed -i 's/1"/1|.*"/g' /opt/tomcat/webapps/manager/META-INF/context.xml
sed -i 's/1"/1|.*"/g' /opt/tomcat/webapps/host-manager/META-INF/context.xml
sed -i '$i<role rolename="admin-gui,manager-gui"/>' /opt/tomcat/conf/tomcat-users.xml
sed -i '$i<user username="admin" password="tomcat" roles="manager-gui,admin-gui"/>' /opt/tomcat/conf/tomcat-users.xml

#Shutdown and Start tomcat apache services 
sh /opt/tomcat/bin/shutdown.sh
sh /opt/tomcat/bin/startup.sh

#Jenkins Installtion
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import http://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install -y jenkins

#Get port 8080 status
netstat -antup | grep 8080
