#! /bin/bash

docker buildx build --platform=linux/amd64 -t currycan/oracle-jdk:8u202 .
# docker build  -t currycan/oracle-jdk:8u202 .

docker push currycan/oracle-jdk:8u202
