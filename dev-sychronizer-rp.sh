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
cd synchronizer/templates
sed -i '36,47d' deployment.yaml

cd ..

ls -ahl
cd ..

helm upgrade synchronizer synchronizer -n development \
--set 'imagePullSecrets[0].name=regcred' \
--set image.repository=docker-registry.osn.com/synchronizer-dev \
--set image.tag=$(Build.BuildId) -f synchronizer/values.yaml \
--install --reset-values
