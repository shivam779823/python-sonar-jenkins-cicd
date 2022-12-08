# python-sonar-jenkins-cicd


#STEPS:

1) Setup Jenkins Server on Compute Engine

```
./jekins-server.sh
```

2) Create GKE cluster

```
gcloud container clusters create jenkins-cd --zone us-central1-a --num-nodes=1
```
3) sonarqube server 
```

docker run -d -p 9000:9000 -v /sonarqube:/opt/sonarqube/data --name=sonarqube sonarqube 
```
3) Configure jenkinsfile and sonar project properties 

4) firewall rule and service account permissions

``` 
 open port 8080 ,9000 
```
  
5) Download key

```
sonarqube credentials
kubernets crdentials

```

6) configure jenkins plugins and add credentials ex. dockerhub.
```
docker plugins
cobertura
sonarscanner
google kubernetes
kubernetes
junit
```


- venv  ( apt install python3-venv )
- pytest-cov
- pylint
- coverage 











