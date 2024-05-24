pipeline {

    agent any

    environment {
        DOCKER_CONFIG = '/tmp/.docker'
        DOCKERHUB_CREDENTIALS = credentials('docker_cred')
    }

    stages{

        stage('Initialize'){
            steps {
                def dockerHome = tool 'docker'
                env.PATH = "${dockerHome}/bin:${env.PATH}"
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

        stage('Docker build & push') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login --username $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
    }
}
