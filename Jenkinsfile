pipeline {
    agent any
    tools {
        maven 'maven-3.8.6'
        dockerTool 'docker-latest'
    }
    stages {
        stage('Maven Install') {
            steps {
                sh 'echo "Maven Install"'
//                 withMaven {
//                     sh 'mvn clean install'
//                 }
            }
        }
        stage('Docker Build') {
            steps {
                sh 'echo "Docker Build"'
                docker {
                    sh 'docker build -t wojberni/spring_demo:latest .'
                }
            }
        }
        stage('Docker Push') {
            steps {
                docker {
                    withCredentials([usernamePassword(
                                    credentialsId: 'docker-hub',
                                    passwordVariable: 'DOCKERHUB_PASSWORD',
                                    usernameVariable: 'DOCKERHUB_USERNAME')]){
                                    sh 'echo "Docker Push"'
                                    sh 'docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD'
                                    sh 'docker push wojberni/spring_demo:latest'
                    }
                }
            }

        }

        stage('Test') {
            steps {
                sh 'echo "Test"'
                // sh 'mvn test'
            }
        }
        stage('Deploy') {
            steps {
                sh 'echo "Deploy"'
            }
        }
    }
}