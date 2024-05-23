#! /bin/bash

docker buildx build --platform=linux/arm64 -t currycan/oracle-jdk:8u202-arm .

docker push currycan/oracle-jdk:8u202-arm
