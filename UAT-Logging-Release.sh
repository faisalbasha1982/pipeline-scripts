#!/bin/bash

unset http_proxy
unset HTTP_PROXY
unset https_proxy
unset HTTPS_PROXY
unset NO_PROXY
unset no_proxy

kubectl get nodes

kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=/home/dotnet_user/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson -n uat

ls -ahl

cd logginguat/templates 

sed -i  's#path: /#path: /swagger/#g'  deployment.yaml

cd ..

ls -ahl

cd ..

helm upgrade logginguat logginguat -n uat \
--set 'imagePullSecrets[0].name=regcred' \
--set image.repository=docker-registry.osn.com/logging-uat \
--set image.tag=$(Build.BuildNumber) \
-f logginguat/values.yaml  --install \

