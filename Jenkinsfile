def img
pipeline {
    environment {
        registry = "hameedakshal/projectguvi"
        DOCKERHUB_CREDENTIALS=credentials('docker-hub-login')
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
                     img = registry + ":${env.BUILD_ID}"
                     println ("${img}")
		     sh "docker build -t ${img} ."
                }
            }
        }
        
        stage('Login'){
	    steps{
		script{
		     sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
		}
	    }
	}

	stage('Push'){
	    steps{
		script{
		     sh "docker push ${img}"
		}
	    }
	}

	stage('Deploy'){
	    steps{
		script{
		     sh "docker run -d -p 5000:5000 ${img}"
		}
	    }
	}
    }
}
