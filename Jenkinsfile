pipeline {
    agent any
    stages {
        stage('Maven Install') {
            agent {
                docker {
                    image 'maven:3.8.5-openjdk-17'
                    args '-v $HOME/.m2:/root/.m2'
                }
            }
            steps {
                sh 'echo "Maven Install"'
                sh 'mvn clean install'
            }
        }
        stage('Docker Build') {
        agent any
            steps {
                sh 'echo "Docker Build"'
                sh 'docker build -t wojberni/spring_demo:latest .'
            }
        }
        stage('Docker Push') {
            steps {
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