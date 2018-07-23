[![Build Status](https://travis-ci.org/jbacon/mongo-scripts.svg?branch=master)](https://travis-ci.org/jbacon/mongo-scripts.svg?branch=master)

# tech-hub-mongodb
My Tech Hub's MongoDB infrastructure stack on Kubernetes.

### pre-reqs
```bash
export TECH_HUB_ENV="development" # "production"
export TECH_HUB_K8S_VERSION="v1.10.2"
export TECH_HUB_MONGO_DB_AUTH_KEY="redacted"
export TECH_HUB_MONGO_DB_ADMIN_PASSWORD="redacted"
export TECH_HUB_MONGO_DB_PORTFOLIO_PASSWORD="redacted"
```
* `development` flag prepares the stack for Docker's local Kubernetes cluster

### deploy
```bash
bash generate_spec.sh | kubectl apply -f -
```

### init
```bash
kubectl create -f mongodb-init-job-spec.yaml
```
* Runs an job to initalize the database like I need it.

### destroy
```bash
bash generate_spec.sh | kubectl delete -f -
```
* Destory everything