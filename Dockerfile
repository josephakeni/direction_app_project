# pull official base image
FROM fabric8/maven-builder
#FROM dockette/mvn

COPY . /data
# set working directory
WORKDIR /data

RUN mvn clean package

RUN cp target/*.jar /tmp/direction.jar

EXPOSE 8080

# start app
ENTRYPOINT ["java", "-jar", "/tmp/direction.jar"]