#!/bin/bash
set -e

if [ "${TECH_HUB_ENV}" == 'production' ]; then
	PERSISTENT_VOLUME='true'
else
	PERSISTENT_VOLUME='false'
fi

K8S_VERSION=$(kubectl version --output json | jq -r '.serverVersion.gitVersion')
K8S_NAMESPACE=$(kubectl get sa default -o json | jq -r '.metadata.namespace')

echo "---"
kubectl create secret generic tech-hub-mongodb-auth-key \
--from-literal="key.txt=${TECH_HUB_MONGO_DB_AUTH_KEY}" \
--output yaml \
--dry-run \
| cat

echo "---"
kubectl create secret generic tech-hub-mongodb-auth-admin-credentials \
--from-literal='user=admin' \
--from-literal="password=${TECH_HUB_MONGO_DB_ADMIN_PASSWORD}" \
--output yaml \
--dry-run \
| cat

echo "---"
kubectl create configmap tech-hub-mongodb-scripts \
--from-file="${PWD}/mongo-scripts/" \
--output yaml \
--dry-run \
| cat

echo "---"
kubectl create secret generic tech-hub-mongodb-auth-portfolio-credentials \
--from-literal='user=portfolio' \
--from-literal="password=${TECH_HUB_MONGO_DB_PORTFOLIO_PASSWORD}" \
--output yaml \
--dry-run \
| cat

if [ "${TECH_HUB_ENV}" != 'production' ]; then
cat ./templates/services/tech-hub-mongodb-replicaset-0-node-port.yaml
cat ./templates/services/tech-hub-mongodb-replicaset-1-node-port.yaml
cat ./templates/services/tech-hub-mongodb-replicaset-2-node-port.yaml
fi

helm fetch \
--repo https://kubernetes-charts.storage.googleapis.com \
--untar \
--destination ${PWD}/ \
--version 3.4.1 \
mongodb-replicaset

helm template \
--kube-version ${K8S_VERSION} \
--name tech-hub \
--namespace ${K8S_NAMESPACE} \
--set image.tag=3.6 \
--set persistentVolume.enabled=${PERSISTENT_VOLUME} \
--set auth.enabled=true \
--set auth.existingKeySecret=tech-hub-mongodb-auth-key \
--set auth.existingAdminSecret=tech-hub-mongodb-auth-admin-credentials \
${PWD}/mongodb-replicaset \
| cat