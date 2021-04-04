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

cd thanos/templates 

sed -i  's#path: /#path: /swagger/#g'  deployment.yaml

cd ..

ls -ahl

cd ..

helm upgrade thanos thanos -n production \
--set 'imagePullSecrets[0].name=regcred' \
--set image.repository=cicd-dev01.osn.com/thanos-prod \
--set image.tag=$(Build.BuildId) -f thanos/values.yaml \
--install


