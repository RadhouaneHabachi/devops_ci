def mail_body = ""
pipeline {
    agent any
    options {
        ansiColor('xterm')
    }

    environment {
        git_url = "https://github.com/RadhouaneHabachi/devops_ci.git"
        git_branch = "main"
        backend_imageName = "redone/backend"
        frontend_imageName = "redone/frontend"
        registryCredentials = "NEXUS_CRED"
        nexus_registry = "localhost:1111"
        nexus_username = "admin"
        nexus_password = "root"
        backendDockerImage = null
        frontendDockerImage = null
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

        stage('Compile maven project') {
            steps {
                script {
                    sh "cd backend; mvn compile; cd .."
                }
            }
        }


        stage('Build backend docker image') {
            steps{
                script {
                    backendDockerImage = docker.build("${backend_imageName}:${env.BUILD_NUMBER}", "backend/")
                }
            }
        }

        stage('Build frontend docker image') {
            steps{
                script {
                    frontendDockerImage = docker.build("${frontend_imageName}:${env.BUILD_NUMBER}", "frontend/")
                }
            }
        }

        stage('Upload backend docker image to Nexus') {
            steps{
                script {
                    docker.withRegistry("http://${nexus_registry}", registryCredentials ) {
                        backendDockerImage.push("${env.BUILD_NUMBER}")
                    }
                    sh "docker rmi ${backend_imageName}:${env.BUILD_NUMBER} -f"
                    sh "docker rmi ${nexus_registry}/${backend_imageName}:${env.BUILD_NUMBER} -f"
                }
            }
        } 

        stage('Upload frontend docker image to Nexus') {
            steps{
                script {
                    docker.withRegistry("http://${nexus_registry}", registryCredentials ) {
                        frontendDockerImage.push("${env.BUILD_NUMBER}")
                    }
                    sh "docker rmi ${frontend_imageName}:${env.BUILD_NUMBER} -f"
                    sh "docker rmi ${nexus_registry}/${frontend_imageName}:${env.BUILD_NUMBER} -f"
                }
            }
        }

        stage('Deploy app to environement') {
            steps{
                script {
                    sh "sed -i \"s/TAG=.*/TAG=${env.BUILD_NUMBER}/\" .env"
                    sh "sed -i \"s/NEXUS_REPOSITORY=.*/NEXUS_REPOSITORY=${nexus_registry}/\" .env"
                    sh "cat .env"
                    sh "docker login http://${nexus_registry} --username ${nexus_username} --password ${nexus_password}"
                    sh "docker-compose down"
                    sh "docker-compose up -d --build"
                }
            }
        }   
    } 

    post {
        always {
            script{
                if (currentBuild.result == "FAILURE" || currentBuild.result == "UNSTABLE") {
                    mail_body += "Project name : *TP-ACHAT* \nBuild#${currentBuild.number} \nStatus: *Failed*\n"
                } else if (currentBuild.result == "SUCCESS") {
                    mail_body += "Project name : *TP-ACHAT* \nBuild#${currentBuild.number} \nStatus: *Succeeded*\n"
                } else if (currentBuild.result == "ABORTED") {
                    mail_body += "Project name : *TP-ACHAT* \nBuild#${currentBuild.number} \nStatus: *Aborted*\n"
                }
                mail_body += "Build URL: ${currentBuild.absoluteUrl}"
            }
            mail to: "habachiradhouane@gmail.com",
            subject: "App deployment N??${env.BUILD_NUMBER}",
            body: mail_body
        }
    }
}