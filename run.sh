#!/bin/sh
# CI deployer agent.

function verify_source() {
  echo "=== verifying source branch"
  if [ ${DRONE_REPO_BRANCH} != "master" ]; then
    echo "Only master branch can be deployed"
    exit 1
  fi

  echo "=== verifying referenced release is tagged"
  if [ -z ${DRONE_TAG##v} ]; then
    echo "Only tagged commits can be deployed"
    exit 1
  fi
}

function kube_setup() {
  if [ ! -f /root/.kube/config ]; then
    echo "=== configuring cluster access"
    echo ${PLUGIN_DEPLOYER_KUBE_CA_DATA} | base64 -d > /root/ca.crt
    kubectl config set-cluster main --server="${PLUGIN_DEPLOYER_KUBE_SERVER}" --certificate-authority="/root/ca.crt"
    kubectl config set-credentials deployer --token=${PLUGIN_DEPLOYER_KUBE_TOKEN}
    kubectl config set-context main --cluster=main --user=deployer --namespace=${DRONE_DEPLOY_TO}
    kubectl config use-context main
    kubectl version
  fi
}

function helm_install() {
  if [ ! -f /root/values.yaml ]; then
    echo ${PLUGIN_DEPLOYER_HELM_RELEASE_VALUES} | base64 -d > /root/values.yaml
  fi
  helm status ${PLUGIN_DEPLOYER_HELM_RELEASE_NAME} 2> /dev/null
  if [ $? -eq 0 ]; then
    echo "=== upgrading existing installation"
  else
    echo "=== running new installation"
  fi
  helm upgrade \
  -f /root/values.yaml \
  --install \
  --reuse-values \
  --debug \
  --version ${DRONE_TAG##v} \
  --wait \
  ${PLUGIN_DEPLOYER_HELM_RELEASE_NAME} ./helm/*
}

# verify source is a tagged release on the master branch
verify_source

# setup cluster access
kube_setup

case $1 in
  deploy)
    echo "=== deploy new version to environment: ${DRONE_DEPLOY_TO}"
    helm_install
    ;;
  rollback)
    echo "=== rollback environment: ${DRONE_DEPLOY_TO}"
    helm_install
    ;;
  *)
    echo "Usage: run {deploy|rollback}"
    exit 1
esac
