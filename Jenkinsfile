pipeline {
   agent any
   stages {
    stage('Checkout SCM') {
      steps {
            echo "Clone git repository [main branch]";
            git branch: "main",
            url: "https://github.com/RadhouaneHabachi/devops_ci.git";
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
          sh "Docker image : ${dockImage} was created successfully !"
        }
      }
    }
    
     stage('Upload docker image to Nexus') {
     steps{  
         script {
             docker.withRegistry('http://localhost:1111', "NEXUS_CRED" ) {
             dockerImage.push("${env.BUILD_NUMBER}")
             sh "Docker image : ${dockImage} was pushed to Nexus repository successfully !"
          }
        }
      }
    }
    
  }
}