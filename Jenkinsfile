pipeline {
    agent any
    options {
        ansiColor('xterm')
    }

    environment {
        git_url = "https://github.com/RadhouaneHabachi/devops_ci.git"
        git_branch = "main"
        imageName = "redone/tp-achat"
        registryCredentials = "NEXUS_CRED"
        nexus_registry = "http://localhost:1111"
        dockerImage = ""
    }

    stages {
        stage('Clone git repository') {
            steps {
                git branch: git_branch,
                url: git_url;
                script {
                    sh "ls -lart ./*"
                }
            }
        }

        // stage('Compile maven project') {
        //     steps {
        //         script {
        //             sh "mvn compile"
        //         }
        //     }
        // }

        // stage('Unit test') {
        //     steps {
        //         script {
        //             sh "mvn test"
        //         }
        //     }
        // }

        stage ('Scan and Build Jar File') {
            steps {
                // withSonarQubeEnv(installationName: 'SonarQube', credentialsId: 'SonarQubeToken') {
                //     sh 'mvn clean package sonar:sonar -DskipTests'
                // }
                script{
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Build docker image') {
            steps{
                script {
                    dockerImage = docker.build "${imageName}:${env.BUILD_NUMBER}"
                }
            }
        }

        stage('Upload docker image to Nexus') {
            steps{
                script {
                    docker.withRegistry(nexus_registry, registryCredentials ) {
                        dockerImage.push("${env.BUILD_NUMBER}")
                    }
                }
            }
        }

        stage('Deploy app to environement') {
            steps{
                script {
                    sh "sed -i \"s/TAG=.*/TAG=${env.BUILD_NUMBER}/\" .env"
                    sh "cat .env"
                    sh "docker-compose up -d"
                }
            }
        }
    }

    // post {
    //     always {
    //         script {
    //             sh "docker rmi ${imageName}:${env.BUILD_NUMBER} -f"
    //             sh "docker rmi localhost:1111/${imageName}:${env.BUILD_NUMBER} -f"
    //         }
    //     }
    // }
}