#!/bin/sh
# CI deployer agent.

verify_source() {
  echo "=== verifying source branch"
  if [ "${DRONE_REPO_BRANCH}" != "master" ]; then
    echo "Only master branch can be deployed"
    exit 1
  fi

  echo "=== verifying referenced release is tagged"
  if [ -z "${DRONE_TAG##v}" ]; then
    echo "Only tagged commits can be deployed"
    exit 1
  fi
}

kube_setup() {
  if [ ! -f /root/.kube/config ]; then
    echo "=== configuring cluster access"
    echo "${PLUGIN_DEPLOYER_KUBE_CA_DATA}" | base64 -d > /root/ca.crt
    kubectl config set-cluster main --server="${PLUGIN_DEPLOYER_KUBE_SERVER}" --certificate-authority="/root/ca.crt"
    kubectl config set-credentials deployer --token="${PLUGIN_DEPLOYER_KUBE_TOKEN}"
    kubectl config set-context main --cluster=main --user=deployer --namespace="${DRONE_DEPLOY_TO}"
    kubectl config use-context main
    kubectl version
  fi
}

helm_install() {
  if [ ! -f /root/values.yaml ]; then
    echo "${PLUGIN_DEPLOYER_HELM_RELEASE_VALUES}" | base64 -d > /root/values.yaml
  fi
  echo "=== version: ${DRONE_TAG##v}"
  echo "=== environment: ${DRONE_DEPLOY_TO}"
  helm upgrade \
  -f /root/values.yaml \
  --install \
  --reuse-values \
  --debug \
  --version "${DRONE_TAG##v}" \
  --wait \
  "${PLUGIN_DEPLOYER_HELM_RELEASE_NAME}" ./helm/*
}

case $1 in
  deploy)
    # verify source is a tagged release on the master branch
    verify_source

    # setup cluster access
    kube_setup

    # deploy
    echo "=== method: deploy"
    helm_install
    ;;
  rollback)
    # verify source is a tagged release on the master branch
    verify_source

    # setup cluster access
    kube_setup

    # deploy
    echo "=== method: rollback"
    helm_install
    ;;
  info)
    # show version of used components
    echo "helm: $(helm version --short)"
    echo "kubectl: $(kubectl version --short --client | cut -d' ' -f3)"
    echo "docker: $(docker -v | cut -d',' -f1 | cut -d' ' -f3)"
    ;;
  *)
    echo "Usage: run {deploy|rollback|info}"
    exit 1
esac
