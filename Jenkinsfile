pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: jnlp
    image: jenkins/inbound-agent
    args: ['-disableHttpsCertValidation', '\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
  - name: git-cmds
    image: alpine/git
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
    image: docker:19
    command:
    - sleep
    args:
    - infinity
    env:
      - name: DOCKER_HOST
        value: tcp://localhost:2375
  - name: dind-daemon
    image: docker:19-dind
    command: [dockerd-entrypoint.sh]
    env:
      - name: DOCKER_TLS_CERTDIR
        value: ""
    securityContext:
        privileged: true
    volumeMounts:
      - name: docker-graph-storage
        mountPath: /var/lib/docker
  volumes:
    - name: docker-graph-storage
      emptyDir: {}
'''
            defaultContainer 'git-cmds'
        }
    }

    stages {
        stage('Init') {
          steps {
            container('git-cmds') {
                sh 'git clone https://github.com/docker/getting-started.git'
            }
          }
        }

        stage('test') {
            steps {
              container('docker-cmds') {
                    script {
                      dir('getting-started') {
                        sh "docker build -t my-image:${env.BUILD_ID} ./"
                      }
                    }
                }
              }
            }
        }
}