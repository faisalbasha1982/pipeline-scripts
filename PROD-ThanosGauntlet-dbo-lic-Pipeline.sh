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


ls -ahl
cd thanos-gauntlet-dbo-lic/templates

sed -i '36,47d' deployment.yaml

echo 'eng@osn' | sudo -S mv deployment.yaml old-deployment.yaml
file='old-deployment.yaml'

while IFS= read -r line;
do
  echo "$line" >> deployment.yaml
  n=$((n+1))
  if [ "$n" -eq 35 ]
  then
       envfile='/home/devadmin/env-python/env-db-lic.txt'
       while IFS= read -r newline;
        do
             echo "$newline" >> deployment.yaml
        done < $envfile
  fi
done < $file

echo 'eng@osn' | sudo -S rm -r $file

cd ..

ls -ahl
cd ..

helm upgrade thanos-gauntlet-dbo-lic thanos-gauntlet-dbo-lic -n production \
--set 'imagePullSecrets[0].name=regcred' \
--set replicaCount=$(replicaCount) \
--set group_id='$(group_id)' \
--set kafka_topic_prefix='$(kafka_topic_prefix)' \
--set image.repository=cicd-dev01.osn.com/thanos-gauntlet-prod \
--set image.tag=$(Build.BuildId) -f thanos-gauntlet-dbo-lic/values.yaml \
--install --reset-values

