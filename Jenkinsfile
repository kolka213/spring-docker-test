pipeline {

    agent any

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

        node {
            def app = docker.build("pascalschwabe/spring-docker-test:${env.BUILD_TAG}")
            app.push()
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'build/*.jar', fingerprint: true
            }
        }
    }
}
