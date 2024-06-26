pipeline {

    agent any

    environment {
        DOCKER_CONFIG = '/tmp/.docker'
        DOCKERHUB_CREDENTIALS = credentials('docker_cred')
    }

    stages{

        stage('Initialize'){
            steps {
                script {
                    def dockerHome = tool 'docker'
                    env.PATH = "${dockerHome}/bin:${env.PATH}"
                }
            }
        }


        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Cleanup') {
            steps {
                // Cleans the local Maven repository
                withMaven(maven: 'Maven-3.9.6') {
                    sh 'mvn dependency:resolve'
                    sh 'mvn clean'
                }
            }
        }

        stage('Build') {
            steps {
                withMaven(maven: 'Maven-3.9.6') {
                    sh 'mvn package'
                }
            }
        }

        stage('Docker login') {
            steps {
                sh 'docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW http://192.168.120.69:5000/v2'
            }
        }

        stage('Docker build') {
            steps {
                sh 'docker build -t http://192.168.120.69/spring-docker-test:latest .'
            }
        }

        stage('Docker push') {
            steps {
                sh 'docker push http://192.168.120.69/spring-docker-test:latest'
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
    }
}
