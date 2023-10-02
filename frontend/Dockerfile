FROM gitlab.praktikum-services.ru:5050/std-012-005/sausage-store/node:12-alpine as builder
WORKDIR /usr/src/app
COPY . .
RUN npm install && npm install -g http-server
RUN npm run build

FROM nginx:latest
WORKDIR /app
COPY --from=builder /usr/src/app/dist/frontend /usr/share/nginx/html
EXPOSE 8080
