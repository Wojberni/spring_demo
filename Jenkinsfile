pipeline {
    agent any
    stages {
        stage('Maven Install') {
            agent {
                docker {
                    image 'maven:3.8.5-openjdk-17'
                }
            }
            steps {
                sh 'mvn clean install'
            }
        }
        stage('Docker Build') {
        agent any
            steps {
                sh 'echo "Build"'
                sh 'docker build -t wojberni/spring_demo:latest .'
            }
        }
        stage('Docker Push') {
            withCredentials([usernamePassword(
            credentialsId: 'docker-hub',
            passwordVariable: 'docker-hubPassword',
            usernameVariable: 'docker-hubUser')]){
                sh "docker login -u ${env.docker-hubUser} -p ${env.docker-hubPassword}"
                sh 'docker push wojberni/spring_demo:latest'
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