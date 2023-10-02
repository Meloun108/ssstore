#!/bin/bash
set +e
docker network create -d bridge sausage_network || true
docker pull gitlab.praktikum-services.ru:5050/std-012-005/sausage-store/sausage-frontend:latest
docker stop frontend || true
docker rm frontend || true
set -e
docker run -d --name frontend \
    --rm -p 80:80 \
    -v /var/run/docker.sock:/tmp/docker.sock:ro \
    gitlab.praktikum-services.ru:5050/std-012-005/sausage-store/sausage-frontend:latest
