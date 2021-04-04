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

cd bobafett/templates 

sed -i  's#path: /#path: /swagger/#g'  deployment.yaml
echo 'eng@osn' | sudo -S mv service.yaml old-service.yaml
file='old-service.yaml'

while IFS= read -r line;
do
  echo "$line" >> service.yaml
  n=$((n+1))
  if [ "$n" -eq 12 ]
  then
       envfile='/home/dotnet_user/nodeport-uat.txt'
       while IFS= read -r newline;
        do
             echo "$newline" >> service.yaml
        done < $envfile
  fi
done < $file

cd ..

ls -ahl

cd ..

helm upgrade bobafett bobafett -n uat \
--set 'imagePullSecrets[0].name=regcred' \
--set service.type='NodePort' \
--set nodePort='32071' \
--set image.repository=docker-registry.osn.com/bobafett-uat \
--set image.tag=$(Build.BuildNumber) -f bobafett/values.yaml \
--install --reset-values

