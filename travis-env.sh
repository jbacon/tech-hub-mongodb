#!/bin/bash
set -e

# TRAVIS SECRETS
# export TECH_HUB_MONGO_DB_AUTH_KEY="redacted"
# export TECH_HUB_MONGO_DB_ADMIN_PASSWORD="redacted"
# export TECH_HUB_MONGO_DB_PORTFOLIO_PASSWORD="redacted"
# export K8S_TOKEN="redacted"
# export K8S_CA_CERT="redacted"

# OTHER VARIABLES
echo -n ${K8S_CA_CERT} | base64 --decode > ${HOME}/ca.cert
curl -LO https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl config set-cluster cluster \
--certificate-authority=${HOME}/ca.cert \
--server='https://35.227.175.60' \
--embed-certs
kubectl config set-credentials user \
--token=$(echo -n ${K8S_TOKEN} | base64 --decode)
kubectl config set-context context \
--cluster='cluster' \
--user='user' \
--namespace='default'
kubectl config use-context context

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > ${HOME}/get_helm.sh
chmod 700 ${HOME}/get_helm.sh
source ${HOME}/get_helm.sh  --version 'v2.9.1'
helm init --client-only