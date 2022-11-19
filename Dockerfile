FROM anapsix/alpine-java 
COPY /target/tpAchatProject-1.0.jar /home/tpAchatProject-1.0.jar 
CMD ["java","-jar","/home/tpAchatProject-1.0.jar","com.esprit.examen.TpAchatProjectApplication"]