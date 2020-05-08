#!/usr/bin/env bash
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker-compose rm -v
docker system prune -f
docker volume prune -f