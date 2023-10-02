#!/bin/bash
set +e
cat > .env <<EOF
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
SPRING_DATA_MONGODB_URI=${SPRING_DATA_MONGODB_URI}
EOF
docker network create -d bridge sausage_network || true
docker pull gitlab.praktikum-services.ru:5050/std-012-005/sausage-store/sausage-backend:latest
if [ "$( docker container inspect -f '{{.State.Health.Status}}' sausage-store-backend-blue )" == "healthy" ]
then
docker stop sausage-store-backend-green || true
docker rm sausage-store-backend-green || true
set -e
docker run -d --name sausage-store-backend-green \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    gitlab.praktikum-services.ru:5050/std-012-005/sausage-store/sausage-backend:latest
fi
sleep 60
if [ "$( docker container inspect -f '{{.State.Health.Status}}' sausage-store-backend-green )" == "healthy" ]
then
docker stop sausage-store-backend-blue || true
docker rm sausage-store-backend-blue || true
set -e
docker run -d --name sausage-store-backend-blue \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    gitlab.praktikum-services.ru:5050/std-012-005/sausage-store/sausage-backend:latest
fi
