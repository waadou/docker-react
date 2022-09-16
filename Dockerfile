FROM node:14-alpine AS development

# Set working directory
WORKDIR /app

COPY ./package.json .
COPY ./package-lock.json .

RUN npm install

COPY . .

ENV CI=true

CMD [ "npm","start" ]
# <----- We are interesting in the folder '/app/build' at the end of this step

FROM development AS build

RUN npm run build

FROM nginx:1.14-alpine

# Copy config nginx
# COPY --from=build /app/.nginx/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# Copy static assets from builder stage
COPY --from=build /app/build .

# Exposing port, that will be mapped automatically by ElasticBeanStalk
EXPOSE 80  

# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]