FROM nginx:alpine
WORKDIR /usr/share/nginx/html
# Remove default nginx static pages
RUN rm -rf ./*
# Copy our web-app over
COPY web-app/* ./
# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]