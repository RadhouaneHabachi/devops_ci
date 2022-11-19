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
    
  }
}