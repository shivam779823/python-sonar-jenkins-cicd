pipeline{
    agent any 

    environment {
        // Kubenetes env
            PROJECT_ID = 'project'
            CLUSTER_NAME = 'jenkins-cd'
            LOCATION = 'us-central1-a'
            CREDENTIALS_ID = 'project'
        // docker env
            dockerImage = "mywebsite"
    }

    stages{

    //step 1  CODE CHECKOUT

       stage("Checkout code") {

            steps {

                 git branch: 'master', url: 'https://github.com/shivam779823/sample2.git'  
            }
    
        }

    //step 2  TESTING CODE  (unit test)

       stage('Unit Tests') {
           steps {

				dir("${env.WORKSPACE}/"){
                        
                    sh 'python3 -m venv venv'
                    sh './venv/bin/pip3 install --upgrade --requirement requirements.txt'
                    sh 'venv/bin/py.test --cov-report xml:coverage.xml --cov=. --junitxml=result.xml  test_main.py'
                    sh 'rm -r venv'

                }

            }
            post {
                always {
                    
                    junit skipMarkingBuildUnstable: true, testResults: 'result.xml'
                    cobertura coberturaReportFile: 'coverage.xml'
                }
            }    
        } 

    //step 3   CODE QUALITIY CHECKS 

       stage('Code Quality Check') {
            steps {
                script {

                def scannerHome = tool 'sonarscanner';

                    withSonarQubeEnv(credentialsId: 'sonarkey'){

                        sh "${tool("sonarscanner")}/bin/sonar-scanner "
                        
                 
                    }
                        
                }
            }
        }

    //step 4   QUALITY GATES

       stage('Quality_Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
                }
            }
        }

    //step 5  IMAGES BUILD USING DOCKER

        stage("Build image") {
            steps {
                script {
                        dockerImage = docker.build("shiva9921/${env.dockerImage}:${env.BUILD_ID}")
                    }
               
            }
        }

    // step 6 PUSH IMAGE REPOSITORY

       stage("Push image") {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhublogin') {
                            dockerImage.push("latest")
                            dockerImage.push("${env.BUILD_ID}")


                            // Remove Image
                            sh "docker rmi -f shiva9921/${env.dockerImage}:${env.BUILD_ID}"
                            echo "image removed"
                            
                    }
                }
                  
            }
        }

    //Step 7  DEPLOYMENT  [ DEV , TEST , STAGING , PRODUCTION  ]

        stage('Deploy dev') {
             when {
                    not { branch 'main' }
                    not { branch 'master' }

             }
            steps{
    
                sh "sed -i 's/mywebsite:latest/${env.dockerImage}:${env.BUILD_ID}/g' k8s/deployment.yaml"

                step([$class: 'KubernetesEngineBuilder', namespace:'dev', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'k8s/deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
 
	            step([$class: 'KubernetesEngineBuilder', namespace:'dev', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'k8s/service.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])

               

                echo "Deployment Finished ..."


                  
            }
        }
    
        stage('Deploy QA/Test') {
             when {
                    not { branch 'main' }
                    not { branch 'master'}
                        {branch 'test'}
             }
            steps{
    
                sh "sed -i 's/mywebsite:latest/${env.dockerImage}:${env.BUILD_ID}/g' k8s/deployment.yaml"

                step([$class: 'KubernetesEngineBuilder', namespace:'test', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'k8s/deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
 
	            step([$class: 'KubernetesEngineBuilder', namespace:'test', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'k8s/service.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])

               

                echo "Deployment Finished ..."


                  
            }
        }

    // APROVAL 

       stage('Approve ') {
            input {
                message "Should we continue to production ?"
                ok "Yes, we should."
                submitter "alice,bob"
                parameters {
                    string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
                }
            }

            steps {

                script{
                    timeout(10) {
                        mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> Go to build url and approve the deployment request <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "deekshith.snsep@gmail.com";  
                        input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
                    }
                }

            } 
       }  


    
        stage('Deploy Production') {

            when { branch 'main' }
            

            steps{
    
                sh "sed -i 's/mywebsite:latest/${env.dockerImage}:${env.BUILD_ID}/g' k8s/deployment.yaml"

                step([$class: 'KubernetesEngineBuilder', namespace:'production', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'k8s/deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
 
	            step([$class: 'KubernetesEngineBuilder', namespace:'production', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'k8s/service.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])

              

                echo "Deployment Finished ..."


                  
            }
        }
    }

    post{
        always{
            always {
			mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "deekshith.snsep@gmail.com";  
		 }
        }
       
    }
  
}






