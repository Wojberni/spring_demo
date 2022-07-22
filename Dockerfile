FROM openjdk:11.0.15-jre
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} spring_demo.jar
ENTRYPOINT ["java", "-jar", "spring_demo.jar"]