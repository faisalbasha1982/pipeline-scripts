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

echo $(Build.BuildNumber)

helm upgrade mydamui mydamui -n development \
--set 'imagePullSecrets[0].name=regcred' \
--set image.repository\
=docker-registry.osn.com/mydam-frontend-dev \
--set image.tag=$(Build.BuildId) -f mydamui/values.yaml \
--install 

#export http_proxy="http://10.250.199.65:3128/"
#export HTTP_PROXY="http://10.250.199.65:3128/"
#export https_proxy="http://10.250.199.65:3128/"
#export HTTPS_PROXY="http://10.250.199.65:3128/"
#export no_proxy="docker-#registry.osn.com,127.0.0.1,localhost,10.206.48.136"
#export NO_PROXY="docker-#registry.osn.com,127.0.0.1,localhost,10.206.48.136"
