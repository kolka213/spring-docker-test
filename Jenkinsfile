pipeline {

    agent any

    environment {
        DOCKER_CONFIG = '/tmp/.docker'
    }

    stages{

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
            agent {
                dockerfile {
                    registryUrl 'https://registry.hub.docker.com'
                    registryCredentialsId 'docker_cred'
                    }
            }
            steps {
                withDockerRegistry(credentialsId: 'docker_cred', toolName: 'docker', url: 'https://registry.hub.docker.com') {
                    echo 'push image'
                }
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
    }
}
