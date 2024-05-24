pipeline {

    agent { label 'Jenkins' }

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

        stage('Dockerhub') {
            agent {
                // Equivalent to "docker build -f Dockerfile.build --build-arg version=1.0.2 ./build/
                dockerfile {
                    filename 'spring-docker-test'
                    dir 'build'
                    label 'docker'
                }
            }
            steps {
                sh "echo running Dockerfile"
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'build/*.jar', fingerprint: true
            }
        }
    }
}
