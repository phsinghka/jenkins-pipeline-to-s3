FROM maven:3.6.3-openjdk-17

WORKDIR /app

COPY pom.xml . 

RUN mvn dependency:go-offline -B

COPY src ./src

RUN mvn clean package -DskipTests

RUN mv target/*.jar target/app.jar

EXPOSE 8080

ENTRYPOINT [ "java", "-jar", "target/app.jar" ]