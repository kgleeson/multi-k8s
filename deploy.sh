#!/bin/bash
docker build -t kgleeson/multi-client:latest -t kgleeson/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t kgleeson/multi-server:latest -t kgleeson/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t kgleeson/multi-worker:latest -t kgleeson/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push kgleeson/multi-client:latest
docker push kgleeson/multi-client:$SHA
docker push kgleeson/multi-server:latest
docker push kgleeson/multi-server:$SHA
docker push kgleeson/multi-worker:latest
docker push kgleeson/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment server=kgleeson/multi-server:$SHA
kubectl set image deployments/client-deployment client=kgleeson/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=kgleeson/multi-worker:$SHA