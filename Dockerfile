FROM openjdk:17-jdk-alpine
MAINTAINER Pascal
LABEL com.centurylinklabs.watchtower.enable="true"
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]