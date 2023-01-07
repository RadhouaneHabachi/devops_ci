FROM node:14.2.0-alpine3.11

RUN npm install -g @angular/cli
WORKDIR /backend
COPY . .
RUN mvn clean install
CMD mvn spring-boot:run