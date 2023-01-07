# Stage 1
FROM node:14.15.4 as node
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build --prod
RUN ls /app/dist/
# Stage 2
FROM nginx:alpine
COPY --from=node /app/dist/crudtuto-Front /usr/share/nginx/html