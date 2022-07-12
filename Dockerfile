FROM openjdk

COPY /target/spring_demo.jar /home/spring_demo.jar
CMD ["java", "-jar", "/home/spring_demo.jar"]