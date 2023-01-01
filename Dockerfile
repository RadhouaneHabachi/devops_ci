FROM openjdk:8-jdk-alpine
EXPOSE 8089
COPY /target/tpAchatProject-1.0.jar /home/tpAchatProject-1.0.jar 
ENTRYPOINT ["java","-jar","/home/tpAchatProject-1.0.jar","com.esprit.examen.TpAchatProjectApplication"]