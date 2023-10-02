#!/bin/bash
set +e
cat > .env <<EOF
DB=${SPRING_DATA_MONGODB_URI}&tlsAllowInvalidCertificates=true
EOF
docker network create -d bridge sausage_network || true
docker pull gitlab.praktikum-services.ru:5050/std-012-005/sausage-store/sausage-backend-report:latest
docker stop backend-report || true
docker rm backend-report || true
set -e
docker run -d --name backend-report \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    gitlab.praktikum-services.ru:5050/std-012-005/sausage-store/sausage-backend-report:latest
