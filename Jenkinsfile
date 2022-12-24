def img
pipeline {
    environment {
        registry = "hameedakshal/projectguvi" //To push an image to Docker Hub, you must first name your local image using your Docker Hub username and the repository name that you created through Docker Hub on the web.
        registryCredential = 'docker-hub-login'
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
        
        stage('Push To DockerHub') {
            steps {
                script {
                    docker.withRegistry( 'https://registry.hub.docker.com ', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }
    }
}













// post {
// 		always {
// 			echo 'The pipeline completed'
// 		}
// 		success {				
// 			echo "successfully pushed to dockerhub"
// 		}
// 		failure {
// 			echo 'Build stage failed'
// 			error('Stopping early…')
// 		}
// 	}
}
















