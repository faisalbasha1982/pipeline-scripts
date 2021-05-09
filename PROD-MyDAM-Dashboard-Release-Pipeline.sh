#!/bin/bash

unset http_proxy
unset HTTP_PROXY
unset https_proxy
unset HTTPS_PROXY
unset NO_PROXY
unset no_proxy

kubectl get nodes


kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=/home/devadmin/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson -n production

cd dashboardui/templates

sed -i '40,47d' deployment.yaml


echo 'eng@osn' | sudo -S mv deployment.yaml old-deployment.yaml
file='old-deployment.yaml'

while IFS= read -r line;
do
  echo "$line" >> deployment.yaml
  n=$((n+1))
  if [ "$n" -eq 6 ]
  then
       envfile='/home/devadmin/thanos-prod-hostname/label.txt'
       while IFS= read -r newline;
        do
             echo "line read $newline"
             echo "$newline" >> deployment.yaml
        done < $envfile
  fi
  if [ "$n" -eq 13 ]
  then
       envfile='/home/devadmin/thanos-prod-hostname/label1.txt'
       while IFS= read -r newline;
        do
             echo "line read $newline"
             echo "$newline" >> deployment.yaml
        done < $envfile
  fi
  if [ "$n" -eq 21 ]
  then
       envfile='/home/devadmin/thanos-prod-hostname/label2.txt'
       while IFS= read -r newline;
        do
             echo "line read $newline"
             echo "$newline" >> deployment.yaml
        done < $envfile
  fi

done < $file

echo 'eng@osn' | sudo -S rm -r $file

echo 'eng@osn' | sudo -S cp -r /home/devadmin/thanos-prod-hostname/service-dashboardui.yaml service.yaml

cd ..

ls -ahl

cd ..


helm upgrade dashboardui dashboardui -n production \
--set 'imagePullSecrets[0].name=regcred' \
--set image.repository\
=cicd-dev01.osn.com/dashboardui \
--set image.tag=$(Build.BuildId) -f dashboardui/values.yaml \
--install 


