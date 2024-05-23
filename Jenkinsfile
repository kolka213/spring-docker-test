pipeline {

    agent docker

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

        stage("Dockerizing"){
            steps {
                script {
                    // Define Docker image name and tag
                    def dockerImage = docker.build("pascalschwabe/spring-docker-test/spring-docker-test:${env.BUILD_ID}")

                    // Login to Docker Hub
                    sh "docker login -u ${env.DOCKER_HUB_USERNAME} -p ${env.DOCKER_HUB_PASSWORD}"

                    // Push Docker image to Docker Hub
                    dockerImage.push()
                }
            }

        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'build/*.jar', fingerprint: true
            }
        }
    }
}
