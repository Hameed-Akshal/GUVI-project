def img
pipeline {
    environment {
        registry = "hameedakshal/projectguvi" //To push an image to Docker Hub, you must first name your local image using your Docker Hub username and the repository name that you created through Docker Hub on the web.
        DOCKERHUB_CREDENTIALS=credentials('docker-hub-login')
        dockerImage = ''
    }
    agent any
    
    stages{
        stage('build checkout'){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Hameed-Akshal/GUVI-project.git']]])
            }
        }
        
        
        stage('build image'){
            steps{
                script{
                     sh 'cd ./'
                     img = registry + ":${env.BUILD_ID}"
                     println ("${img}")
                     dockerImage = docker.build("${img}")
                }
            }
        }
        
        stage('Login') {

			steps {
				sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
			}
		}

		stage('Push') {

			steps {
				sh 'docker push hameedakshal/projectguvi:latest'
			}
		}
    }
}
