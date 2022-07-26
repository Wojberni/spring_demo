pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
metadata:
  name: dind-jenkins
spec:
    containers:
      - name: jnlp
        image: jenkins/inbound-agent
        args: ['-disableHttpsCertValidation', '\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
      - name: maven-cmds
        image: maven:3.8.6-openjdk-11
        command:
        - sleep
        args:
        - infinity
        securityContext:
          privileged: true
        volumeMounts:
          - name: docker-graph-storage
            mountPath: /var/lib/docker
      - name: docker-cmds
        image: docker:20.10.17
        command:
        - sleep
        args:
        - infinity
        resources:
            requests:
                cpu: 10m
                memory: 256Mi
        env:
          - name: DOCKER_HOST
            value: tcp://localhost:2375
      - name: dind-daemon
        image: docker:20.10.17-dind
        command: [dockerd-entrypoint.sh]
        env:
        - name: DOCKER_TLS_CERTDIR
          value: ""
        resources:
            requests:
                cpu: 20m
                memory: 512Mi
        securityContext:
            privileged: true
        volumeMounts:
          - name: docker-graph-storage
            mountPath: /var/lib/docker
    volumes:
      - name: docker-graph-storage
        emptyDir: {}
'''
            defaultContainer 'docker-cmds'
        }
    }
    stages {
        stage('Maven Install') {
            steps {
                container('maven-cmds') {
                    sh 'mvn clean install'
                }
            }
        }
        stage('Docker Build') {
            steps {
                container('docker-cmds') {
                    sh 'docker build -t kielmikolaj/repo:latest .'
                }
            }
        }
        stage('Docker Push') {
            steps {
                container('docker-cmds') {
                    withCredentials([usernamePassword(
                                    credentialsId: 'kielmikolaj_dockerhub',
                                    passwordVariable: 'DOCKERHUB_PASSWORD',
                                    usernameVariable: 'DOCKERHUB_USERNAME')]){
                                    sh 'docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD'
                                    sh 'docker push kielmikolaj/repo:latest'
                    }
                }
            }

        }
    }
}
