#!/bin/bash
set +e
cat > .env <<EOF
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
SPRING_DATA_MONGODB_URI=${SPRING_DATA_MONGODB_URI}
DB=${SPRING_DATA_MONGODB_URI}&tlsAllowInvalidCertificates=true
EOF
set -e
docker stop backend || true
docker rm backend || true
docker stop frontend || true
docker rm frontend || true
docker stop backend-report || true
docker rm backend-report || true
docker stop sausage-store-frontend || true
docker rm sausage-store-frontend || true
docker stop sausage-store-backend-report || true
docker rm sausage-store-backend-report || true
if [ "$( docker container inspect -f '{{.State.Health.Status}}' sausage-store-backend-blue )" == "healthy" ]
then
docker stop sausage-store-backend-green || true
docker rm sausage-store-backend-green || true
docker-compose --env-file .env up -d backend-green
fi
sleep 60
if [ "$( docker container inspect -f '{{.State.Health.Status}}' sausage-store-backend-green )" == "healthy" ]
then
docker stop sausage-store-backend-blue || true
docker rm sausage-store-backend-blue || true
docker-compose --env-file .env up -d backend-blue
fi
docker-compose --env-file .env up -d backend-report
docker-compose --env-file .env up -d frontend
#docker-compose --env-file .env up -d
