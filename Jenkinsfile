pipeline {
   agent any
    environment {
        git_url = "https://github.com/RadhouaneHabachi/devops_ci.git"
        git_branch = "main"
        imageName = "redone/tpatachat"
        registryCredentials = "NEXUS_CRED"
        nexus_registry = "http://localhost:1111"
        dockerImage = ""
    }
   stages {
    stage('Checkout SCM') {
      steps {
            echo "Clone git repository";
            git branch: git_branch,
            url: git_url;
            script {
                sh "ls -lart ./*"
                sh "pwd"
                sh "whoami"
            }
       }
    }
    
    stage('Compile maven project') {
      steps {
            script {
                sh "mvn compile"
            }
       }
    }
    
    stage('Unit test') {
      steps {
            script {
                sh "mvn test"
            }
       }
    }
    stage ('Scan and Build Jar File') {
        steps {
           withSonarQubeEnv(installationName: 'SonarQube', credentialsId: 'SonarQubeToken') {
            sh 'mvn clean package sonar:sonar -DskipTests'
            }
        }
    }
    
     stage('Build docker image') {
      steps{
        script {
          dockerImage = docker.build "redone/tpatachat:${env.BUILD_NUMBER}"
        }
      }
    }
    
     stage('Upload docker image to Nexus') {
     steps{  
         script {
             docker.withRegistry(nexus_registry, registryCredentials ) {
             dockerImage.push(${env.BUILD_NUMBER})
          }
        }
      }
    }
    
  }
}