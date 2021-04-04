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
    --type=kubernetes.io/dockerconfigjson -n development

ls -ahl

cd loggingdev/templates 

sed -i  's#path: /#path: /swagger/#g'  deployment.yaml

cd ..

ls -ahl

cd ..

helm upgrade loggingdev loggingdev -n development \
--set 'imagePullSecrets[0].name=regcred' \
--set image.repository=docker-registry.osn.com/logging-dev \
--set image.tag=$(Build.BuildNumber) \
-f loggingdev/values.yaml  --install \


