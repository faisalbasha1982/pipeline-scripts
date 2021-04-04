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

cd thanosuat/templates 

sed -i  's#path: /#path: /swagger/#g'  deployment.yaml

cd ..

ls -ahl

cd ..

helm upgrade thanosuat thanosuat -n uat \
--set 'imagePullSecrets[0].name=regcred' \
--set image.repository=docker-registry.osn.com/thanos-uat \
--set image.tag=$(Build.BuildNumber) -f thanosuat/values.yaml \
--install

#export http_proxy="http://10.250.199.65:3128/"
#export HTTP_PROXY="http://10.250.199.65:3128/"
#export https_proxy="http://10.250.199.65:3128/"
#export HTTPS_PROXY="http://10.250.199.65:3128/"
#export no_proxy="docker-#registry.osn.com,127.0.0.1,localhost,10.206.48.136"
#export NO_PROXY="docker-#registry.osn.com,127.0.0.1,localhost,10.206.48.136"

