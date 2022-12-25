Guvi project (DevOps Intern Task)

1. Basic directory structure
     

        |----Dockerfile
        |----app.py
        |----Jenkinsfile
        |----requirements.txt

2. requirements.txt  consists of

   ![](https://lh5.googleusercontent.com/OORtoO5gw-9Ytl6ST2h4qnRC9MGaldONxdtCvH9O5iL11HPc4PXWIJDqZdU8rXpmNXowtEWYpQMNdf5zAUelHySFT-9vqzcP12uD4QnQkRvSK6I-H3GcQV2XGCa_kxERd3yswlwj5Fe8B84LCSk_iZHVYz8mUBjWNRMRoL9oRrhJ3ROnd_5CpTR2J6qvkQ)

3. Make the flask application run locally using python3 app.py. Tested the root  from the browser and got the expected response

![](https://lh3.googleusercontent.com/Dpn-DtaZ_ncvyaJsXbPpQXXcjTnuBIJX9PuPyatxqje3WQ5aWLcjwuWkiq1KPotUqc5eTuC4ldg4pA3tW8f2Td_-ccqiPd2vHeOF5I-pNr38Ktqr-sP1SXJEprJGAeyIQAShc-a-U4GoA8x0Prn3Ybz_D_Saaoi0uUtICVM_f_mdbi6IV8YMy57sDVAWRQ)

4. Dockerfile is used to create a docker container and consists of 
```
# syntax=docker/dockerfile:1

FROM python:3.8-slim-buster

WORKDIR /python-docker

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

COPY . .

CMD \[ “python3”, “-m”, ”flask” , “run” , “--host=0.0.0.0”]
```
Used python 3.8 version and chose slim-buster in order to reduce the size of the docker images. This can help us deploy the docker image faster. Created a working directory as ‘/python-docker’. Copied only requirements.txt because docker images are built layer by layer. Whenever the bottom layer gets changed, all the layers above them are rebuilt. So, application code changes often however, dependencies won't change much. Moreover, building the dependencies takes more time during the building process. Downloading and Installation of all the required dependencies is done using the command pip3 install. The source code is copied to the container and “CMD \[ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]”This line specifically instructs Docker to run our Flask app as a module, as indicated by the "-m" tag. Then it instructs Docker to make the container available externally, such as from our browser, rather than just from within the container. We pass the host port as 0.0.0.0

5. Jenkinsfile contains two environment variables (Docker Repository name and Docker Hub Credentials). It has 5 Stages.
*  build checkout: At this stage, the code is pulled from the Github Repository from the main branch. Syntax is created from the Pipeline Syntax generator in Jenkins UI 
*  build image: Docker build is used to build the image. This will use the Above Dockerfile and creates all the layers
*  Login: Logged in to the Docker Hub 
*  Push: Pushed the build image to the DockerHub repository
*  Deploy: Ran the docker container in the port 5000. 

```
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
```
6. Create ubuntu instance and install Docker and Jenkins

	1\. Signed in to aws console, go to ec2 dashboard and click create or launch instance      

	2\. Type the name of the instance![](https://lh3.googleusercontent.com/2Qdlg8LsWzGFMJMwZwRNcxoVJgjVZhSm2YZ7FdxVxD5IDl7CIlyTaKAZhxgikwr3n6bBs7D5RqeqPLMC02xuIEIw9lMF_AwgmVJh7QQT0LozxEKoUL3gDbYADGPsuqJPWYVV7QqGEXE9HSjuY_rUYoTjOd7tJmcikFvK6v-xR7YScbu843aMxz5P4_EiSA)

	   Select the os as ubuntu 

	3\. Here we Selected the instance type as t3.medium

	![](https://lh4.googleusercontent.com/1T5mr6dcbmBTRPbgqg5hnGHiMNPv_14f3uECBk4ssdYpTyYF_Ah2HirLr8pyC6i2iU2y7-EG-IQRbmz42sjqGVdzdoCiMMPE89wOAJtCUTxjZ6YadA8kkf2Boy18hQgXXJRF3lunzFtS5S637_PNyubbSHHLs6qu_YG34gMPjHujbbOXl4jG8wGinQRIrA)



	4\. Select your key pair and security group and leave every thing default then click launch instance 

	5\. The instance will be created 

	![](https://lh3.googleusercontent.com/wqbsjHgQkxIAazk9y09IFWgH_3advkCEt-3ehCjRBO1mwEYvBK0XM0Vle9AcHTYvxi9zwm7yNtbH41--VYrUjCrek_k-LmMbFzJfz_S04XljvO5qzr-m8zWOnAZ5oYZ3CGBlQw_bnexQVb6PcTONGRG1c0CRT1Jjo574K5gdXzTaADbso3boNlej0BA9_g)

	6\. Then connect the instance using instance connect or through ssh           ![](https://lh5.googleusercontent.com/0svQmeADYlUwK6yHMwKMpaApzyAdX0HjcCc14FT4-pRnyptX0picKziPCUkeOPjkzqivMZ2jrnFT_RO1FGf5mmpmtNIF0CxkPzQxuLCMpVd6VGmt27ZWGw6mQjtWKwLyuHlUxYp2Hdb-xHnPbw9WrhANf8otSzrgpYaphbJEUnde5E4gcAVz646uSbihaA)

After connect to instance


## Installing docker

1. Below Command is used to update the package manager
```
sudo apt update
```
2.  Below Command is used to install Docker. -y for denoting yes
```
sudo apt install docker.io -y
```

3. Check whether Docker was properly installed by running the status command or checking the program version. To see the Docker daemon status, run:

```
sudo systemctl status docker
```

4. check the program  by running:
```
docker 
```

![](https://lh4.googleusercontent.com/oBa0gwijBVuPJUl1WmCh4bmBQTmKy77SOMgCJD3HjlbPmF8zAE7ThHTErJoYkmfzuWut0ChtQZFoqz2KKwvKoEbVY2KEDfhfJzGxrce4S170FI9hD-mrAZEYH8n0F5-Dfe3OnGXi7y_nioB6e75l3K3GxNETprmkO-cXKFciyS00Urn_RBLVML_4F7vMQw)

\*sudo is used for root access purpose because we signed in as a non root user


## Installing Jenkins

1. This is the Debian package repository of Jenkins to automate installation and upgrade. To use this repository, first add the key to your system:
```
 curl -fsSL https&#x3A;//pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
```
2. Then add a Jenkins apt repository entry:
```
 echo deb \[signed-by=/usr/share/keyrings/jenkins-keyring.asc] \\

    https&#x3A;//pkg.jenkins.io/debian-stable binary/ | sudo tee \\

    /etc/apt/sources.list.d/jenkins.list > /dev/null
```
3. Update your local package index, then finally install Jenkins:
```
 sudo apt-get update

 sudo apt-get install fontconfig openjdk-11-jre

 sudo apt-get install jenkins
```
4. Check whether jenkins installed or not: 
```
 ps -ef | grep jenkins
```
5. Open a browser and Navigate to your server ip use the following syntax:    
 ``` 
  <http://ip_address_or_domain:8080> 
 ```
 ![](https://lh4.googleusercontent.com/3EHSI2Xr4zA5C7Wt4FXJI0cg9RFjO7EKhwVtmhKFW37XcJtHEseupEewCTl7qLc66olmzhWgJT4uM5lC4OynQUMr_Lfvfqa5e6gNCMLtpdcn5xUUXzoezqNwLmdillyN52mi-yGUHLvSRKGYRGU7oG_20P_FDH10cp0rsCvH0LH4nom7uH8mYI-dk3b9ZA)
 6. Below command is used in terminal to get the passord for Jenkins:
 ```
 sudo cat /var/lib/jenkins/secrets/initialAdminPassword 
 ```
 then copy the text and paste here then click continue
 
 ![](https://lh3.googleusercontent.com/jct3mO2QA1crVnvsfoS0CtXd_nwqRWuoT9x1Cba9NI5MOi3Y8W1U0cf53pGfp9bQs4KbrxGcqx-tkWYZrE1dYyh3XQnCqUYRTLy6QOe-44L-pI0z-OPkvMHuqBRoPQK3e-zU8FvMInCKLxXDSAhVsed5oUWDXkgy7Xp3UKbduPikvXXtas8-CFYWxeXTmw)
 8. Select install suggested plugins and click continue then Provide the details 
![](https://lh6.googleusercontent.com/dzw37YEI_49NzOiUEtygfplMaooH9CCh3_sGFXwigV7QtNpWi6FmobWQYXwaO8c9Bju0cwR1Rx2Udcd3tNku3oBekhIIwkwnKAMxJFcagxPdwy2a4gK_jnctU8Glt3fIFpz26-LjgUYbpx4v1soYEN9wtByTa1jv3p5Bns_gJbkvHnBhXheINVUWjJMOsQ)
 9. Click save and continue 

![](https://lh5.googleusercontent.com/ru965-HO9d5Cv5YfzbvRm_6apkZiFnGmQeUfUdfmHLlCExLJWOxwsbO0h1uim2GidLx69XQX2zJpgFejuSO1lKec-ggZvKTHmEnepVVqiD3vtz_1Gdcu0xBvxJNTRJ5fvcPs8QvimoqFrjp7Vq-Un7uf1thznBukVIVFHuIdLJNKwVqu6KlawHnRsLYYQQ)


### Build pipeline

1. Go to dashboard -> Manage jenkins -> credentials -> system -> Global credentials  and provide credentials of github and dockerhub.

![](https://lh4.googleusercontent.com/O_Eml8delMywv_M7T1qnSLFL0WpqEAhO8wBFRofvzr-Q9a5_UHc-kSL-QCMxSt_U1rHjEefK2uXmnJiZoTPBsJUPneRWaMhN6zb2FYLChB0ND_TXIwfqc19Jn0acBL6EbG2oGcdKTInzMlWRnYUcWYz4VvMIgeGPWWtyZyn4kxBpoucMq05oj4tnH6wxFw)

2. Go to dashboard -> Manage jenkins -> Manage plugins and select docker pipeline plugin and click install without restart 
3. In Dashboard click new and Enter name and click ok 

![](https://lh3.googleusercontent.com/M29qGZROFhfC88UDNzGCxtll1N0xCP27uW6jIBOEITj_GDVY6VlQpEAlPkqlzXzJf2_FY8z0mRHql1rYbXqmzEY_RVht_SgMc0fwZTXaiQFYRQwHUowoLT29wzz5RQ_5KQQGb5UPv_5u9w3Hi-MrAnJZYcC49dD3a1-o_wRmXZANj3apOFj2Zf0-dIp-Xg)

4. In configuration Enable Github project and provide the project url and in build trigger enable github hook triggerfor gitscm polling and pool scm ![](https://lh3.googleusercontent.com/ChKqcFV7uKZPPjpvUro1oR_g3twRh450nYTAvDPm0JfOcUW_50D-PxxT2iEdYmqlAxxqjnNQ2uxor0N5iMGIpoAeSseQeNTV1JNAnMhbPvxkxE3uVCpFN5hfaUCQZMRSVzNT2yb3Nefb-sQS-BGLdIFmj1Mfg7T1QxnFxVKMjM50u14__-0Nh7ZJrQZfyw)
5. In Pipeline                ![](https://lh3.googleusercontent.com/qayoSj_T0pk-IRO7C8NZDyNXvgMh-jLMwwHGwz-WAG4T9PFjzTCG6P-RGWfCz1ysaDdKuIryIqkv0iarNBhNzy1moBuN-Nrnr_Fni5jY5c5t-afNloxCUT_r6S5t7I5_dbk6NCKF02YHzA7oNc2pao4Gg-n2yaa2bqkSYgZD4-oWYNsFhp40K-L0eiQ-IQ)![](https://lh6.googleusercontent.com/0CVNXqNR4XAPAztSv6aSeZCzDcYPU21P-Sn7kc5e0lLtyOPEjh9wwJS-7-X9WbOo1acy4u631uWOdTHBg_pTdQWjmJLcl5781S_ziIWk9_sUdN4EaEXWYnC6_0uH3XpteHkLz9piIGMkO1RivSaEbeTpwLsL0oQlwskkQXls2EvWBrhnwj-Y240on6J7Kw)

      Click save

6. Now we are going trigger jenkins from github  In project repositiry -> settings -> webhook -> add webhook  and In Payload url 

     “ <http://instanceip:8080/github-webhook/>” 
     
     and select content type as application/json

     Then click add webhook 

![](https://lh5.googleusercontent.com/xQvpmokBYsQ4iTHtDtuHvGQKaLRGTOpmkGMphLbQhZlN61GDO1W2wz74_z0HpuVVQxr1Z-ZR_zsVM4tQ3IvdTBRsG_0sA6yyEP2nSpJzj3ziza3a_VGGwMLa3D6ZOFpytigL1JbOfI8rwxdue_5vaV3l6Z3VUBUU6slKqMuGBXOdpDa56LrWJNYVI8OVew)

  


7. After enabling WebHooks , commit the changes in git then it will trigger and execute pipeline  

![](https://lh5.googleusercontent.com/D8BBCN42lV8Vcjo1pPaC12FT97ZuJUX5jEI25DyVLHP_W0luvSQJcycHDHS1HcVC96x7dFdKQJ09vt9fmjG64TIg5pGeNq7NIL-SC388MhNiYH_ZTIyc7ok-59NefAJ0jJBez3O4jT0cFOwze5LTjIWB0h8FRLfEyHKXFcZkXcRBNVRFdYVMjbU2V60OtQ)

8. In dockerhub   

![](https://lh3.googleusercontent.com/G0sR1yP8Ny_jmcXScs2b0K3UIoOQFJ57TMLLMLkU3qf1DTvPtHBTLniqiod34InoYVeI-Af8JFu_ZvtVxmTtGWFPWhuU3kYpkpOgsylLAny_JXfZAf0ahm4uUdQ3KmIOTyPzx-Q33v1bES_WsgH9RkZGZglp62by_5aPW6tg6jWC8hUKh64JYW8HDq5ckA)

9. Deployed output
                 ![](https://lh4.googleusercontent.com/Ht3jgugdZ5WGODP1oL_Xi8HTJbazUEt57A3xW_UV2AimcNQj6NhlcTmRDKaxtUHLV08uSfO4efXX4kri03vbh64NCEXfrqLenyH3RfjxV2ObOlmZrdtsOZ2qGInTLfJETYHBuHrHcVCbKjlu3QiQsw9coy_IXx92kINmhdYT39Ldm07SYaj4IWMReEC0pA)
11. Application is working 

### DockerHub Repository Link: 

https://hub.docker.com/repository/docker/hameedakshal/projectguvi/general
### Reference:
Python Flask App : https://www.freecodecamp.org/news/how-to-dockerize-a-flask-app/

Docker Installation Link: https://phoenixnap.com/kb/install-docker-on-ubuntu-20-04

Jenkins Installation Link: https://pkg.jenkins.io/debian-stable/




