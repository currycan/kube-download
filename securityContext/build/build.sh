#!/usr/bin/env bash

docker build -t currycan/stress-app:0.0.5-apline .
docker build -t currycan/stress-app:0.0.5 .

docker push currycan/stress-app:0.0.5
docker push currycan/stress-app:0.0.5-apline


docker buildx build --platform=linux/arm64 -t currycan/stress-app:0.0.6-arm . -f Dockerfile-arm
docker push currycan/stress-app:0.0.6-arm

docker buildx build --platform=linux/amd64 -t currycan/stress-app:0.0.6 . -f Dockerfile-x86
docker push currycan/stress-app:0.0.6
