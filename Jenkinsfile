pipeline {

    agent any

    stages{
        stage('Initialize') {
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

        stage('Docker build & push') {
            agent {
                dockerfile {
                    registryUrl 'https://registry.hub.docker.com'
                    registryCredentialsId 'dd14a04d-2cd3-401a-a237-b002b02b86b8'
                    args '-v /tmp:/tmp'
                    }
            }
            steps {
                withDockerRegistry(credentialsId: 'dd14a04d-2cd3-401a-a237-b002b02b86b8', toolName: 'docker', url: 'https://registry.hub.docker.com') {
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
