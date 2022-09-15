FROM node:14-alpine AS builder

WORKDIR /app

COPY ./package.json .
COPY ./package-lock.json .

RUN npm install

COPY . .

CMD [ "npm","run", "build" ]
# <----- We are interesting in the folder '/app/build' at the end of this step

FROM nginx
EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html
