#!/bin/bash

apt install wget
apt install unzip
mkdir /downloads/sonarqube -p
cd /downloads/sonarqube
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip
unzip sonar-scanner-cli-4.2.0.1873-linux.zip
mv sonar-scanner-4.2.0.1873-linux /opt/sonar-scanner


#optional
vi  /opt/sonar-scanner/conf/sonar-scanner.properties

# sonar.host.url=http://localhost:9000
# sonar.sourceEncoding=UTF-8

tee /etc/profile.d/sonar-scanner.sh <<EOF
#!/bin/bash
export PATH="$PATH:/opt/sonar-scanner/bin"  
EOF
  

env | grep PATH

sonar-scanner -v


echo "success"