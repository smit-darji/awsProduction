FROM nginx:alpine
WORKDIR /app
COPY ./index.html /usr/share/nginx/html
ENTRYPOINT ["nginx", "-g", "daemon off;"]